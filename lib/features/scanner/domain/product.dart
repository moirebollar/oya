import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.ean,
    required this.productName,
    this.brands,
    this.imageUrl,
    this.greenScoreGrade,
    this.greenScoreScore,
    this.nutriScoreGrade,
    this.novaGroup,
    this.labelsTags = const [],
    this.categoriesTags = const [],
    this.pnnsGroups2,
    this.source = 'off',
  });

  final String ean;
  final String productName;
  final String? brands;
  final String? imageUrl;
  final String? greenScoreGrade; // 'A'–'E' or null
  final int? greenScoreScore;   // 0–100
  final String? nutriScoreGrade;
  final int? novaGroup;
  final List<String> labelsTags;
  final List<String> categoriesTags;
  final String? pnnsGroups2;
  final String source;

  bool get hasGreenScore =>
      greenScoreGrade != null && greenScoreGrade != 'unknown';

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      ean: data['ean'] as String,
      productName: data['productName'] as String? ?? '',
      brands: data['brands'] as String?,
      imageUrl: data['imageUrl'] as String?,
      greenScoreGrade: data['greenScoreGrade'] as String?,
      greenScoreScore: (data['greenScoreScore'] as num?)?.toInt(),
      nutriScoreGrade: data['nutriScoreGrade'] as String?,
      novaGroup: (data['novaGroup'] as num?)?.toInt(),
      labelsTags: List<String>.from(data['labelsTags'] as List? ?? []),
      categoriesTags:
          List<String>.from(data['categoriesTags'] as List? ?? []),
      pnnsGroups2: data['pnnsGroups2'] as String?,
      source: data['source'] as String? ?? 'off',
    );
  }

  Map<String, dynamic> toMap() => {
        'ean': ean,
        'productName': productName,
        if (brands != null) 'brands': brands,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (greenScoreGrade != null) 'greenScoreGrade': greenScoreGrade,
        if (greenScoreScore != null) 'greenScoreScore': greenScoreScore,
        if (nutriScoreGrade != null) 'nutriScoreGrade': nutriScoreGrade,
        if (novaGroup != null) 'novaGroup': novaGroup,
        'labelsTags': labelsTags,
        'categoriesTags': categoriesTags,
        if (pnnsGroups2 != null) 'pnnsGroups2': pnnsGroups2,
        'source': source,
      };

  @override
  List<Object?> get props => [ean, productName, greenScoreGrade, source];
}
