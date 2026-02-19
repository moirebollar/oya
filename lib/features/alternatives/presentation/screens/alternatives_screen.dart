import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oya/l10n/app_localizations.dart';
import 'package:oya/features/alternatives/presentation/widgets/comparison_card.dart';
import 'package:oya/features/alternatives/providers/alternatives_provider.dart';
import 'package:oya/features/scanner/providers/scanner_provider.dart';

class AlternativesScreen extends ConsumerWidget {
  const AlternativesScreen({super.key, required this.ean});

  final String ean;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentAsync = ref.watch(productProvider(ean));
    final alternativesAsync = ref.watch(alternativesProvider(ean));

    return Scaffold(
      appBar: AppBar(title: Text(l.alternativesTitle)),
      body: alternativesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (alternatives) {
          if (alternatives.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 72, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l.alternativesEmpty,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(l.alternativesSubtitle,
                    style: TextStyle(color: Colors.grey[600])),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: alternatives.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return currentAsync.maybeWhen(
                        data: (current) => current != null
                            ? ComparisonCard(product: current, isCurrent: true)
                            : const SizedBox.shrink(),
                        orElse: SizedBox.shrink,
                      );
                    }
                    final alt = alternatives[index - 1];
                    return ComparisonCard(
                      product: alt,
                      onTap: () => context.push('/scan/product/${alt.ean}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
