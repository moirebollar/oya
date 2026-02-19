import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oya/features/store_finder/data/overpass_api_client.dart';
import 'package:oya/features/store_finder/data/store_repository.dart';
import 'package:oya/features/store_finder/domain/sustainable_store.dart';

class MockOverpassApiClient extends Mock implements OverpassApiClient {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockOverpassApiClient mockOverpass;
  late StoreRepository repo;

  // Amsterdam coordinates
  const testLat = 52.3676;
  const testLng = 4.9041;

  const testStores = [
    SustainableStore(
      osmId: 'node/123456',
      name: 'Ekoplaza Amsterdam',
      lat: 52.368,
      lng: 4.905,
      address: 'Nieuwe Spiegelstraat 1, Amsterdam',
      openingHours: 'Mo-Sa 09:00-20:00',
      isOrganic: true,
      isZeroWaste: false,
      shopType: 'health_food',
    ),
    SustainableStore(
      osmId: 'node/654321',
      name: 'Odin Biologisch',
      lat: 52.370,
      lng: 4.908,
      isOrganic: true,
      isZeroWaste: false,
      shopType: 'organic',
    ),
  ];

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockOverpass = MockOverpassApiClient();
    repo = StoreRepository(
      firestore: fakeFirestore,
      overpassClient: mockOverpass,
    );
  });

  group('StoreRepository.getNearbyStores', () {
    test('fetches from Overpass on cache miss, writes to Firestore', () async {
      when(() => mockOverpass.findStores(
            lat: testLat,
            lng: testLng,
            radiusMeters: any(named: 'radiusMeters'),
          )).thenAnswer((_) async => testStores);

      final result = await repo.getNearbyStores(lat: testLat, lng: testLng);

      expect(result.length, 2);
      expect(result.first.name, 'Ekoplaza Amsterdam');
      verify(() => mockOverpass.findStores(
            lat: testLat,
            lng: testLng,
            radiusMeters: any(named: 'radiusMeters'),
          )).called(1);

      // Verify cache was written
      final geohash = _geohash4(testLat, testLng);
      final cached =
          await fakeFirestore.collection('store_cache').doc(geohash).get();
      expect(cached.exists, isTrue);
    });

    test('returns cached stores on cache hit (within 24 hours)', () async {
      final geohash = _geohash4(testLat, testLng);

      // Pre-populate fresh cache
      await fakeFirestore.collection('store_cache').doc(geohash).set({
        'geohash': geohash,
        'radiusMeters': 5000,
        'stores': testStores.map((s) => s.toMap()).toList(),
        'cachedAt': Timestamp.fromDate(DateTime.now()),
      });

      final result = await repo.getNearbyStores(lat: testLat, lng: testLng);

      expect(result.length, 2);
      // Overpass must NOT have been called
      verifyNever(() => mockOverpass.findStores(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
            radiusMeters: any(named: 'radiusMeters'),
          ));
    });

    test('re-fetches from Overpass when cache is expired (> 24 hours)',
        () async {
      final geohash = _geohash4(testLat, testLng);

      // Pre-populate stale cache (25 hours ago)
      await fakeFirestore.collection('store_cache').doc(geohash).set({
        'geohash': geohash,
        'radiusMeters': 5000,
        'stores': testStores.map((s) => s.toMap()).toList(),
        'cachedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 25))),
      });

      when(() => mockOverpass.findStores(
            lat: testLat,
            lng: testLng,
            radiusMeters: any(named: 'radiusMeters'),
          )).thenAnswer((_) async => testStores);

      await repo.getNearbyStores(lat: testLat, lng: testLng);

      // Overpass MUST have been called because cache was stale
      verify(() => mockOverpass.findStores(
            lat: testLat,
            lng: testLng,
            radiusMeters: any(named: 'radiusMeters'),
          )).called(1);
    });
  });

  group('StoreRepository.getStoreById', () {
    test('returns the correct store by osmId', () {
      final store = repo.getStoreById(testStores, 'node/123456');
      expect(store, isNotNull);
      expect(store!.name, 'Ekoplaza Amsterdam');
    });

    test('returns null when osmId not found', () {
      final store = repo.getStoreById(testStores, 'node/999999');
      expect(store, isNull);
    });
  });
}

// Mirror of the private geohash helper in StoreRepository for test assertions.
const _base32chars = '0123456789bcdefghjkmnpqrstuvwxyz';
String _toBase32(int value) {
  final mod = value % _base32chars.length;
  final div = (value ~/ _base32chars.length) % _base32chars.length;
  return '${_base32chars[div]}${_base32chars[mod]}';
}

String _geohash4(double lat, double lng) {
  final latCell = ((lat + 90) / 2).floor();
  final lngCell = ((lng + 180) / 2).floor();
  return '${_toBase32(latCell)}${_toBase32(lngCell)}';
}
