import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/features/scanner/data/product_repository.dart';
import 'package:oya/features/scanner/domain/product.dart';
import 'package:oya/features/scanner/providers/scanner_provider.dart';

final alternativesProvider =
    FutureProvider.family<List<Product>, String>((ref, ean) async {
  final product = await ref.watch(productProvider(ean).future);
  if (product == null) return [];

  final client = ref.watch(offProductClientProvider);
  final category = product.categoriesTags.isNotEmpty
      ? product.categoriesTags.first
      : null;

  if (category == null) return [];

  return client.searchAlternatives(
    categoryTag: category,
    minGrade: product.greenScoreGrade ?? 'e',
  );
});
