import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:oya/features/scanner/domain/product.dart' as oya;

class OffProductClient {
  static void configure() {
    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'OYA',
      version: '1.0.0',
      system: 'Flutter',
      comment: 'Sustainable grocery companion - contact@oyaapp.com',
    );
    OpenFoodAPIConfiguration.globalLanguages = [
      OpenFoodFactsLanguage.ENGLISH,
      OpenFoodFactsLanguage.DUTCH,
      OpenFoodFactsLanguage.SPANISH,
    ];
  }

  Future<oya.Product?> getProduct(String barcode) async {
    final config = ProductQueryConfiguration(
      barcode,
      version: ProductQueryVersion.v3,
      fields: [
        ProductField.BARCODE,
        ProductField.NAME,
        ProductField.BRANDS,
        ProductField.IMAGE_FRONT_URL,
        ProductField.ECOSCORE_GRADE,
        ProductField.ECOSCORE_SCORE,
        ProductField.NUTRISCORE,
        ProductField.NOVA_GROUP,
        ProductField.LABELS_TAGS,
        ProductField.CATEGORIES_TAGS,
      ],
    );

    final result = await OpenFoodAPIClient.getProductV3(config);
    if (result.status != ProductResultV3.statusSuccess ||
        result.product == null) {
      return null;
    }

    return _mapProduct(barcode, result.product!);
  }

  Future<List<oya.Product>> searchAlternatives({
    required String categoryTag,
    required String minGrade,
  }) async {
    const gradeOrder = ["a", "b", "c", "d", "e"];
    final minIndex = gradeOrder.indexOf(minGrade.toLowerCase());

    final params = ProductSearchQueryConfiguration(
      parametersList: [
        TagFilter.fromType(
          tagFilterType: TagFilterType.CATEGORIES,
          tagName: categoryTag,
        ),
        const SortBy(option: SortOption.ECOSCORE),
        const PageSize(size: 10),
        const PageNumber(page: 1),
      ],
      version: ProductQueryVersion.v3,
      fields: [
        ProductField.BARCODE,
        ProductField.NAME,
        ProductField.BRANDS,
        ProductField.IMAGE_FRONT_URL,
        ProductField.ECOSCORE_GRADE,
        ProductField.ECOSCORE_SCORE,
        ProductField.NUTRISCORE,
        ProductField.NOVA_GROUP,
        ProductField.LABELS_TAGS,
        ProductField.CATEGORIES_TAGS,
      ],
    );

    final result = await OpenFoodAPIClient.searchProducts(null, params);
    final products = result.products ?? [];
    return products
        .where((p) {
          final grade = p.ecoscoreGrade?.toLowerCase();
          if (grade == null) return false;
          final idx = gradeOrder.indexOf(grade);
          return idx != -1 && (minIndex == -1 || idx < minIndex);
        })
        .map((p) => _mapProduct(p.barcode ?? "", p))
        .toList();
  }

  oya.Product _mapProduct(String barcode, Product p) {
    return oya.Product(
      ean: barcode,
      productName: p.productName ?? "",
      brands: p.brands,
      imageUrl: p.imageFrontUrl,
      greenScoreGrade: p.ecoscoreGrade,
      greenScoreScore: p.ecoscoreScore?.toInt(),
      nutriScoreGrade: p.nutriscore,
      novaGroup: p.novaGroup,
      labelsTags: p.labelsTags ?? [],
      categoriesTags: p.categoriesTags ?? [],
    );
  }
}
