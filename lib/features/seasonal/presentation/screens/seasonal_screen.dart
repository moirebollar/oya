import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/l10n/app_localizations.dart';
import 'package:oya/features/seasonal/presentation/widgets/seasonal_item_card.dart';
import 'package:oya/features/seasonal/providers/seasonal_provider.dart';

class SeasonalScreen extends ConsumerWidget {
  const SeasonalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final selectedMonth = ref.watch(selectedMonthProvider);
    final itemsAsync = ref.watch(seasonalItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.seasonalTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _MonthSelector(
            selectedMonth: selectedMonth,
            onMonthSelected: (month) =>
                ref.read(selectedMonthProvider.notifier).select(month),
          ),
        ),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.eco_outlined, size: 72, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l.seasonalEmpty,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => SeasonalItemCard(
              item: items[index],
              currentMonth: selectedMonth,
            ),
          );
        },
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final String selectedMonth;
  final void Function(String) onMonthSelected;

  static const _months = [
    '01', '02', '03', '04', '05', '06',
    '07', '08', '09', '10', '11', '12',
  ];
  static const _labels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 12,
        itemBuilder: (context, i) {
          final isSelected = _months[i] == selectedMonth;
          return GestureDetector(
            onTap: () => onMonthSelected(_months[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
