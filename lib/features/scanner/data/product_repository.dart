import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/core/firebase/firebase_providers.dart';
import 'package:oya/features/scanner/data/off_product_client.dart';
import 'package:oya/features/scanner/domain/product.dart';

class ProductRepository {
  const ProductRepository({
    required FirebaseFirestore firestore,
    required OffProductClient offClient,
  })  : _firestore = firestore,
        _offClient = offClient;

  final FirebaseFirestore _firestore;
  final OffProductClient _offClient;

  static const _cacheTtlDays = 7;

  Future<Product?> getProduct(String ean) async {
    // 1. Check Firestore cache
    final doc = await _firestore.collection('products').doc(ean).get();
    if (doc.exists) {
      final data = doc.data()!;
      final cachedAt = (data['cachedAt'] as Timestamp?)?.toDate();
      final isExpired = cachedAt == null ||
          DateTime.now().difference(cachedAt).inDays >= _cacheTtlDays;
      if (!isExpired) {
        return Product.fromMap(data);
      }
    }

    // 2. Fetch from Open Food Facts
    final product = await _offClient.getProduct(ean);
    if (product == null) return null;

    // 3. Write to cache
    await _firestore.collection('products').doc(ean).set({
      ...product.toMap(),
      'cachedAt': FieldValue.serverTimestamp(),
    });

    return product;
  }
}

final offProductClientProvider = Provider<OffProductClient>((ref) {
  return OffProductClient();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    firestore: ref.watch(firestoreProvider),
    offClient: ref.watch(offProductClientProvider),
  );
});
