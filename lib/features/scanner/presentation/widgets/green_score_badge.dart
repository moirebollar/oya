import 'package:flutter/material.dart';
import 'package:oya/core/theme/app_colors.dart';

class GreenScoreBadge extends StatelessWidget {
  const GreenScoreBadge({
    super.key,
    required this.grade,
    this.size = BadgeSize.medium,
    this.showLabel = true,
  });

  final String? grade;
  final BadgeSize size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.greenScoreColor(grade);
    final letter = grade?.toUpperCase() ?? '?';
    final dim = size == BadgeSize.small ? 36.0 : size == BadgeSize.large ? 64.0 : 48.0;
    final fontSize = size == BadgeSize.small ? 16.0 : size == BadgeSize.large ? 28.0 : 20.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dim,
          height: dim,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(dim * 0.25),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        if (showLabel && size != BadgeSize.small) ...[
          const SizedBox(height: 4),
          Text(
            'Green Score',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

enum BadgeSize { small, medium, large }
