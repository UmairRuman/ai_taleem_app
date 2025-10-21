import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taleem_ai/core/theme/app_colors.dart';

Widget buildBackgroundDecorations() {
  return SizedBox.expand(
    // 👈 forces full width/height
    child: Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.08),
                  AppColors.primary.withOpacity(0.02),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.06),
                  AppColors.secondary.withOpacity(0.01),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.info.withOpacity(0.05),
                  AppColors.info.withOpacity(0.01),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 200,
          right: 0,
          child: Opacity(
            opacity: 0.03,
            child: Icon(
              Icons.school_rounded,
              size: 200.w,
              color: AppColors.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 20,
          child: Opacity(
            opacity: 0.02,
            child: Icon(
              Icons.menu_book_rounded,
              size: 180.w,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    ),
  );
}
