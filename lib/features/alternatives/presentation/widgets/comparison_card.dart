import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oya/core/theme/app_colors.dart';
import 'package:oya/features/scanner/domain/product.dart';
import 'package:oya/features/scanner/presentation/widgets/green_score_badge.dart';

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({
    super.key,
    required this.product,
    this.isCurrent = false,
    this.onTap,
  });

  final Product product;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent ? AppColors.primary : AppColors.divider,
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Current',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            const SizedBox(height: 8),
            if (product.imageUrl != null)
              CachedNetworkImage(
                imageUrl: product.imageUrl!,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
                errorWidget: (_, _, _) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 48,
                  color: AppColors.outline,
                ),
              )
            else
              const SizedBox(
                height: 80,
                width: 80,
                child: Icon(Icons.shopping_bag_outlined,
                    size: 48, color: AppColors.outline),
              ),
            const SizedBox(height: 12),
            GreenScoreBadge(
              grade: product.greenScoreGrade,
              size: BadgeSize.medium,
              showLabel: false,
            ),
            const SizedBox(height: 8),
            Text(
              product.productName.isEmpty ? 'Unknown' : product.productName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (product.brands != null) ...[
              const SizedBox(height: 2),
              Text(
                product.brands!,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
