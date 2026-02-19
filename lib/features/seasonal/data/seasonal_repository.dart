import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/core/firebase/firebase_providers.dart';
import 'package:oya/features/seasonal/domain/seasonal_item.dart';

class SeasonalRepository {
  const SeasonalRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<SeasonalItem>> getByMonthAndCountry({
    required String month, // '01'–'12'
    required String country, // 'NL' | 'ES'
  }) async {
    final doc = await _firestore
        .collection('seasonal_produce')
        .doc(country)
        .collection('months')
        .doc(month)
        .get();

    if (!doc.exists) return [];

    final rawItems = doc.data()!['items'] as List<dynamic>? ?? [];
    return rawItems
        .map((item) =>
            SeasonalItem.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}

final seasonalRepositoryProvider = Provider<SeasonalRepository>((ref) {
  return SeasonalRepository(firestore: ref.watch(firestoreProvider));
});
