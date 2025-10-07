// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Education-focused (Calming Blue & Green)
  static const Color primary = Color(0xFF2196F3); // Trustworthy Blue
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryVariant = Color(0xFF1565C0);

  // Secondary Colors - Growth & Success (Green)
  static const Color secondary = Color(0xFF4CAF50); // Success Green
  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color secondaryVariant = Color(0xFF2E7D32);

  // Accent Colors - Engaging (Pakistani Flag Green)
  static const Color accent = Color(0xFF01924A); // Pakistan Green
  static const Color accentLight = Color(0xFF4DB871);
  static const Color accentDark = Color(0xFF006837);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFFECEFF1);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color surfaceDark = Color(0xFFE0E0E0);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnBackground = Color(0xFF212121);
  static const Color textOnSurface = Color(0xFF212121);

  // Border & Divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFEEEEEE);
  static const Color borderDark = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFEEEEEE);

  // Shadow
  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x3D000000);

  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x4D000000);

  // Grade-Specific Colors (for visual differentiation)
  static const Color grade6 = Color(0xFF42A5F5); // Blue
  static const Color grade6Light = Color(0xFF90CAF9);
  static const Color grade6Dark = Color(0xFF1976D2);

  static const Color grade7 = Color(0xFF66BB6A); // Green
  static const Color grade7Light = Color(0xFFA5D6A7);
  static const Color grade7Dark = Color(0xFF388E3C);

  static const Color grade8 = Color(0xFFAB47BC); // Purple
  static const Color grade8Light = Color(0xFFCE93D8);
  static const Color grade8Dark = Color(0xFF7B1FA2);

  // Difficulty Level Colors
  static const Color easy = Color(0xFF4CAF50);
  static const Color easyLight = Color(0xFF81C784);
  static const Color easyDark = Color(0xFF388E3C);

  static const Color medium = Color(0xFFFF9800);
  static const Color mediumLight = Color(0xFFFFB74D);
  static const Color mediumDark = Color(0xFFF57C00);

  static const Color hard = Color(0xFFF44336);
  static const Color hardLight = Color(0xFFE57373);
  static const Color hardDark = Color(0xFFD32F2F);

  // Progress Colors
  static const Color progressIncomplete = Color(0xFFE0E0E0);
  static const Color progressInProgress = Color(0xFF2196F3);
  static const Color progressComplete = Color(0xFF4CAF50);

  // Dashboard/Chart Colors
  static const Color chartBlue = Color(0xFF2196F3);
  static const Color chartGreen = Color(0xFF4CAF50);
  static const Color chartOrange = Color(0xFFFF9800);
  static const Color chartRed = Color(0xFFF44336);
  static const Color chartPurple = Color(0xFF9C27B0);
  static const Color chartYellow = Color(0xFFFFC107);
  static const Color chartCyan = Color(0xFF00BCD4);
  static const Color chartPink = Color(0xFFE91E63);

  // Special UI Colors
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Prevent instantiation
  AppColors._();
}
