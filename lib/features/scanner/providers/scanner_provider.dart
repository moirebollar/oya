import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/features/scanner/data/product_repository.dart';
import 'package:oya/features/scanner/domain/product.dart';

final productProvider =
    FutureProvider.family<Product?, String>((ref, ean) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProduct(ean);
});
