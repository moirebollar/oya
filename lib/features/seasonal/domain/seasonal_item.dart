import 'package:equatable/equatable.dart';

class SeasonalItem extends Equatable {
  const SeasonalItem({
    required this.id,
    required this.nameNl,
    required this.nameEs,
    required this.nameEn,
    this.descriptionNl,
    this.descriptionEs,
    this.descriptionEn,
    this.imageUrl,
    this.peakMonths = const [],
    this.availableMonths = const [],
    this.categories = const [],
    this.source,
  });

  final String id;
  final String nameNl;
  final String nameEs;
  final String nameEn;
  final String? descriptionNl;
  final String? descriptionEs;
  final String? descriptionEn;
  final String? imageUrl;
  final List<String> peakMonths;
  final List<String> availableMonths;
  final List<String> categories;
  final String? source;

  String localizedName(String languageCode) {
    switch (languageCode) {
      case 'nl':
        return nameNl;
      case 'es':
        return nameEs;
      default:
        return nameEn;
    }
  }

  String? localizedDescription(String languageCode) {
    switch (languageCode) {
      case 'nl':
        return descriptionNl;
      case 'es':
        return descriptionEs;
      default:
        return descriptionEn;
    }
  }

  bool isPeak(String month) => peakMonths.contains(month);

  factory SeasonalItem.fromMap(Map<String, dynamic> data) {
    return SeasonalItem(
      id: data['id'] as String,
      nameNl: data['nameNl'] as String? ?? '',
      nameEs: data['nameEs'] as String? ?? '',
      nameEn: data['nameEn'] as String? ?? '',
      descriptionNl: data['descriptionNl'] as String?,
      descriptionEs: data['descriptionEs'] as String?,
      descriptionEn: data['descriptionEn'] as String?,
      imageUrl: data['imageUrl'] as String?,
      peakMonths: List<String>.from(data['peakMonths'] as List? ?? []),
      availableMonths: List<String>.from(data['availableMonths'] as List? ?? []),
      categories: List<String>.from(data['categories'] as List? ?? []),
      source: data['source'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, nameEn];
}
