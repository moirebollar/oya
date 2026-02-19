import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/core/firebase/firebase_providers.dart';
import 'package:oya/features/store_finder/data/overpass_api_client.dart';
import 'package:oya/features/store_finder/domain/sustainable_store.dart';

class StoreRepository {
  const StoreRepository({
    required FirebaseFirestore firestore,
    required OverpassApiClient overpassClient,
  })  : _firestore = firestore,
        _overpassClient = overpassClient;

  final FirebaseFirestore _firestore;
  final OverpassApiClient _overpassClient;

  static const _cacheTtlHours = 24;

  Future<List<SustainableStore>> getNearbyStores({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
  }) async {
    final geohash = _geohash4(lat, lng);

    // Check cache
    final doc = await _firestore.collection('store_cache').doc(geohash).get();
    if (doc.exists) {
      final data = doc.data()!;
      final cachedAt = (data['cachedAt'] as Timestamp?)?.toDate();
      final isExpired = cachedAt == null ||
          DateTime.now().difference(cachedAt).inHours >= _cacheTtlHours;
      if (!isExpired) {
        final rawStores = data['stores'] as List<dynamic>? ?? [];
        return rawStores
            .map((s) => SustainableStore.fromMap(Map<String, dynamic>.from(s as Map)))
            .toList();
      }
    }

    // Fetch from Overpass
    final stores = await _overpassClient.findStores(
      lat: lat,
      lng: lng,
      radiusMeters: radiusMeters,
    );

    // Write to cache
    await _firestore.collection('store_cache').doc(geohash).set({
      'geohash': geohash,
      'radiusMeters': radiusMeters,
      'stores': stores.map((s) => s.toMap()).toList(),
      'cachedAt': FieldValue.serverTimestamp(),
    });

    return stores;
  }

  SustainableStore? getStoreById(
      List<SustainableStore> stores, String osmId) {
    try {
      return stores.firstWhere((s) => s.osmId == osmId);
    } catch (_) {
      return null;
    }
  }

  // Simple 4-character geohash approximation using grid cells
  String _geohash4(double lat, double lng) {
    // ~40km x 20km cells (good enough for a 5km query cache)
    final latCell = ((lat + 90) / 2).floor();
    final lngCell = ((lng + 180) / 2).floor();
    return '${_toBase32(latCell)}${_toBase32(lngCell)}';
  }

  static const _base32chars = '0123456789bcdefghjkmnpqrstuvwxyz';
  String _toBase32(int value) {
    final mod = value % _base32chars.length;
    final div = (value ~/ _base32chars.length) % _base32chars.length;
    return '${_base32chars[div]}${_base32chars[mod]}';
  }
}

final overpassClientProvider = Provider<OverpassApiClient>((ref) {
  return OverpassApiClient();
});

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(
    firestore: ref.watch(firestoreProvider),
    overpassClient: ref.watch(overpassClientProvider),
  );
});
