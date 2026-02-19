import 'package:flutter/material.dart';
import 'package:oya/core/theme/app_colors.dart';

class NutriScoreBadge extends StatelessWidget {
  const NutriScoreBadge({super.key, required this.grade});

  final String? grade;

  @override
  Widget build(BuildContext context) {
    final grades = ['A', 'B', 'C', 'D', 'E'];
    final colors = [
      AppColors.nutriScoreA,
      AppColors.nutriScoreB,
      AppColors.nutriScoreC,
      AppColors.nutriScoreD,
      AppColors.nutriScoreE,
    ];
    final selectedIndex =
        grades.indexOf(grade?.toUpperCase() ?? '');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final isSelected = i == selectedIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 36 : 28,
          height: isSelected ? 36 : 28,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: colors[i].withValues(alpha: isSelected ? 1.0 : 0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              grades[i],
              style: TextStyle(
                color: Colors.white,
                fontSize: isSelected ? 16 : 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }),
    );
  }
}
