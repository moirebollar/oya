import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oya/l10n/app_localizations.dart';
import 'package:oya/core/theme/app_colors.dart';
import 'package:oya/features/scanner/domain/product.dart';
import 'package:oya/features/scanner/presentation/widgets/green_score_badge.dart';
import 'package:oya/features/scanner/presentation/widgets/nutri_score_badge.dart';
import 'package:oya/features/scanner/providers/scanner_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.ean});

  final String ean;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final productAsync = ref.watch(productProvider(ean));

    return Scaffold(
      appBar: AppBar(
        title: const Text('OYA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(ean: ean, message: e.toString()),
        data: (product) {
          if (product == null) return _NotFoundBody(ean: ean);
          return _ProductBody(product: product, ean: ean, l: l);
        },
      ),
    );
  }
}

class _ProductBody extends StatelessWidget {
  const _ProductBody({required this.product, required this.ean, required this.l});

  final Product product;
  final String ean;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          if (product.imageUrl != null)
            CachedNetworkImage(
              imageUrl: product.imageUrl!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.contain,
              placeholder: (_, _) => Container(
                height: 220,
                color: AppColors.surfaceVariant,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, _, _) => Container(
                height: 220,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.image_not_supported_outlined, size: 48),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & brand
                Text(product.productName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700)),
                if (product.brands != null) ...[
                  const SizedBox(height: 4),
                  Text(product.brands!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],

                const SizedBox(height: 24),

                // Scores row
                Row(
                  children: [
                    Expanded(
                      child: _ScoreCard(
                        title: l.productGreenScore,
                        child: GreenScoreBadge(
                          grade: product.greenScoreGrade,
                          size: BadgeSize.large,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ScoreCard(
                        title: l.productNutriScore,
                        child: NutriScoreBadge(grade: product.nutriScoreGrade),
                      ),
                    ),
                  ],
                ),

                if (product.novaGroup != null) ...[
                  const SizedBox(height: 12),
                  _ScoreCard(
                    title: '${l.productNova} ${product.novaGroup}',
                    child: _NovaBar(group: product.novaGroup!),
                  ),
                ],

                // Certifications
                if (product.labelsTags.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(l.productCertifications,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.labelsTags
                        .take(8)
                        .map((tag) => Chip(
                              label: Text(_formatTag(tag)),
                              avatar: const Icon(Icons.verified_outlined,
                                  size: 16, color: AppColors.primary),
                            ))
                        .toList(),
                  ),
                ],

                // Alternatives button
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () =>
                      context.push('/scan/product/$ean/alternatives'),
                  icon: const Icon(Icons.compare_arrows),
                  label: Text(l.productAlternatives),
                ),

                // Attribution
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  l.productDataSource,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                Text(
                  l.productGreenScoreSource,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTag(String tag) {
    return tag
        .replaceAll('en:', '')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 12),
          Center(child: child),
        ],
      ),
    );
  }
}

class _NovaBar extends StatelessWidget {
  const _NovaBar({required this.group});

  final int group;

  static const colors = [
    AppColors.greenScoreA,
    AppColors.greenScoreB,
    AppColors.greenScoreD,
    AppColors.greenScoreE,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final active = i < group;
        return Expanded(
          child: Container(
            height: 12,
            margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
            decoration: BoxDecoration(
              color: active ? colors[i] : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _NotFoundBody extends StatelessWidget {
  const _NotFoundBody({required this.ean});

  final String ean;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l.scanNotFound,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.scanNotFoundSub,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: Text(l.scanAddToOFF),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.ean, required this.message});

  final String ean;
  final String message;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: AppColors.error),
            const SizedBox(height: 16),
            Text(l.errorGeneric,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pop(),
              child: Text(l.errorRetry),
            ),
          ],
        ),
      ),
    );
  }
}
