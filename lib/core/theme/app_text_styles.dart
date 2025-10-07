// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Font Families
  static const String primaryFont = 'Poppins';
  static const String urduFont = 'NotoNastaliqUrdu';

  // Display Styles (Extra Large)
  static TextStyle display1({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 48.sp,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.2,
    letterSpacing: isUrdu ? 0 : -0.5,
  );

  static TextStyle display2({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.2,
    letterSpacing: isUrdu ? 0 : -0.5,
  );

  // Heading Styles
  static TextStyle h1({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.3,
    letterSpacing: isUrdu ? 0 : -0.5,
  );

  static TextStyle h2({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.3,
    letterSpacing: isUrdu ? 0 : -0.25,
  );

  static TextStyle h3({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.3,
    letterSpacing: isUrdu ? 0 : 0,
  );

  static TextStyle h4({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.4,
    letterSpacing: isUrdu ? 0 : 0,
  );

  static TextStyle h5({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.4,
    letterSpacing: isUrdu ? 0 : 0,
  );

  static TextStyle h6({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.0 : 1.4,
    letterSpacing: isUrdu ? 0 : 0.15,
  );

  // Body Text Styles
  static TextStyle bodyLarge({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.2 : 1.5,
    letterSpacing: isUrdu ? 0 : 0.15,
  );

  static TextStyle bodyMedium({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.textPrimary,
    height: isUrdu ? 2.2 : 1.5,
    letterSpacing: isUrdu ? 0 : 0.25,
  );

  static TextStyle bodySmall({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.textSecondary,
    height: isUrdu ? 2.2 : 1.4,
    letterSpacing: isUrdu ? 0 : 0.4,
  );

  // Button Text Styles
  static TextStyle button({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textOnPrimary,
    letterSpacing: isUrdu ? 0 : 0.5,
    height: isUrdu ? 2.0 : 1.0,
  );

  static TextStyle buttonSmall({Color? color, bool isUrdu = false}) =>
      TextStyle(
        fontFamily: isUrdu ? urduFont : primaryFont,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textOnPrimary,
        letterSpacing: isUrdu ? 0 : 0.5,
        height: isUrdu ? 2.0 : 1.0,
      );

  // Caption & Label Styles
  static TextStyle caption({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.textSecondary,
    height: isUrdu ? 2.0 : 1.4,
    letterSpacing: isUrdu ? 0 : 0.4,
  );

  static TextStyle label({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textPrimary,
    letterSpacing: isUrdu ? 0 : 0.1,
    height: isUrdu ? 2.0 : 1.4,
  );

  static TextStyle labelSmall({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textSecondary,
    letterSpacing: isUrdu ? 0 : 0.5,
    height: isUrdu ? 2.0 : 1.4,
  );

  // Overline Style
  static TextStyle overline({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textSecondary,
    letterSpacing: isUrdu ? 0 : 1.5,
    height: isUrdu ? 2.0 : 1.4,
  );

  // Link Style
  static TextStyle link({Color? color, bool isUrdu = false}) => TextStyle(
    fontFamily: isUrdu ? urduFont : primaryFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.primary,
    decoration: TextDecoration.underline,
    height: isUrdu ? 2.0 : 1.5,
  );

  // Prevent instantiation
  AppTextStyles._();
}
