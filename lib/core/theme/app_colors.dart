import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFF8BC34A);
  static const Color accent = Color(0xFFFF8F00);

  // Green Score palette (A–E)
  static const Color greenScoreA = Color(0xFF1A7F37);
  static const Color greenScoreB = Color(0xFF85BB2F);
  static const Color greenScoreC = Color(0xFFF5CB01);
  static const Color greenScoreD = Color(0xFFEE8100);
  static const Color greenScoreE = Color(0xFFE63E11);
  static const Color greenScoreUnknown = Color(0xFF9E9E9E);

  // Nutri-Score palette (A–E)
  static const Color nutriScoreA = Color(0xFF038141);
  static const Color nutriScoreB = Color(0xFF85BB2F);
  static const Color nutriScoreC = Color(0xFFFECC02);
  static const Color nutriScoreD = Color(0xFFEE8100);
  static const Color nutriScoreE = Color(0xFFE63E11);

  // Neutrals
  static const Color background = Color(0xFFF9FAF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5EC);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color outline = Color(0xFFCAC4D0);
  static const Color divider = Color(0xFFE0E0E0);

  // Semantic
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFF8F00);
  static const Color info = Color(0xFF1565C0);

  static Color greenScoreColor(String? grade) {
    switch (grade?.toUpperCase()) {
      case 'A':
        return greenScoreA;
      case 'B':
        return greenScoreB;
      case 'C':
        return greenScoreC;
      case 'D':
        return greenScoreD;
      case 'E':
        return greenScoreE;
      default:
        return greenScoreUnknown;
    }
  }

  static Color nutriScoreColor(String? grade) {
    switch (grade?.toUpperCase()) {
      case 'A':
        return nutriScoreA;
      case 'B':
        return nutriScoreB;
      case 'C':
        return nutriScoreC;
      case 'D':
        return nutriScoreD;
      case 'E':
        return nutriScoreE;
      default:
        return greenScoreUnknown;
    }
  }
}
