import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oya/features/scanner/data/off_product_client.dart';
import 'package:oya/features/scanner/data/product_repository.dart';
import 'package:oya/features/scanner/domain/product.dart';

class MockOffProductClient extends Mock implements OffProductClient {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockOffProductClient mockClient;
  late ProductRepository repo;

  const testEan = '3017620422003';
  const testProduct = Product(
    ean: testEan,
    productName: 'Nutella',
    brands: 'Ferrero',
    greenScoreGrade: 'e',
    greenScoreScore: 12,
    nutriScoreGrade: 'e',
    novaGroup: 4,
    labelsTags: [],
    categoriesTags: ['en:spreads'],
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockClient = MockOffProductClient();
    repo = ProductRepository(firestore: fakeFirestore, offClient: mockClient);
  });

  group('ProductRepository.getProduct', () {
    test('returns null when OFF API returns null', () async {
      when(() => mockClient.getProduct(testEan)).thenAnswer((_) async => null);
      final result = await repo.getProduct(testEan);
      expect(result, isNull);
      verify(() => mockClient.getProduct(testEan)).called(1);
    });

    test('fetches from OFF API on cache miss and writes to Firestore', () async {
      when(() => mockClient.getProduct(testEan))
          .thenAnswer((_) async => testProduct);
      final result = await repo.getProduct(testEan);
      expect(result, isNotNull);
      expect(result!.ean, testEan);
      expect(result.productName, 'Nutella');
      verify(() => mockClient.getProduct(testEan)).called(1);
      final cached =
          await fakeFirestore.collection('products').doc(testEan).get();
      expect(cached.exists, isTrue);
      expect(cached.data()!['productName'], 'Nutella');
    });

    test('returns cached product on cache hit within 7 days', () async {
      await fakeFirestore.collection('products').doc(testEan).set({
        ...testProduct.toMap(),
        'cachedAt': Timestamp.fromDate(DateTime.now()),
      });
      final result = await repo.getProduct(testEan);
      expect(result, isNotNull);
      expect(result!.ean, testEan);
      verifyNever(() => mockClient.getProduct(testEan));
    });

    test('re-fetches from OFF API when cache is expired over 7 days', () async {
      await fakeFirestore.collection('products').doc(testEan).set({
        ...testProduct.toMap(),
        'cachedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 8))),
      });
      when(() => mockClient.getProduct(testEan))
          .thenAnswer((_) async => testProduct);
      final result = await repo.getProduct(testEan);
      expect(result, isNotNull);
      verify(() => mockClient.getProduct(testEan)).called(1);
    });
  });
}
