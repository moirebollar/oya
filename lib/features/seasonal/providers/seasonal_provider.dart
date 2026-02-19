import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/core/firebase/firebase_providers.dart';
import 'package:oya/features/auth/data/auth_repository.dart';
import 'package:oya/features/seasonal/data/seasonal_repository.dart';
import 'package:oya/features/seasonal/domain/seasonal_item.dart';

class SelectedMonthNotifier extends Notifier<String> {
  @override
  String build() {
    final now = DateTime.now();
    return now.month.toString().padLeft(2, '0');
  }

  void select(String month) {
    state = month;
  }
}

final selectedMonthProvider =
    NotifierProvider<SelectedMonthNotifier, String>(SelectedMonthNotifier.new);

final seasonalItemsProvider =
    FutureProvider.autoDispose<List<SeasonalItem>>((ref) async {
  final month = ref.watch(selectedMonthProvider);
  final authState = ref.watch(authStateProvider);
  final uid = authState.value?.uid;

  String country = 'NL'; // default
  if (uid != null) {
    final repo = ref.read(authRepositoryProvider);
    final profile = await repo.getUserProfile(uid);
    country = profile?.country ?? 'NL';
    if (country == 'OTHER') country = 'NL';
  }

  return ref
      .watch(seasonalRepositoryProvider)
      .getByMonthAndCountry(month: month, country: country);
});
