// lib/core/theme/app_dimensions.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  // Make these getters instead of static variables
  static double get paddingXS => 4.w;
  static double get paddingS => 8.w;
  static double get paddingM => 16.w;
  static double get paddingL => 24.w;
  static double get paddingXL => 32.w;
  static double get paddingXXL => 48.w;

  // Border Radius
  static double get radiusXS => 2.r;
  static double get radiusS => 4.r;
  static double get radiusM => 8.r;
  static double get radiusL => 12.r;
  static double get radiusXL => 16.r;
  static double get radiusXXL => 24.r;
  static double get radiusCircular => 100.r;

  // Icon Sizes
  static double get iconXS => 12.w;
  static double get iconS => 16.w;
  static double get iconM => 24.w;
  static double get iconL => 32.w;
  static double get iconXL => 48.w;
  static double get iconXXL => 64.w;

  // Button Heights
  static double get buttonHeightS => 36.h;
  static double get buttonHeightM => 48.h;
  static double get buttonHeightL => 56.h;
  static double get buttonHeightXL => 64.h;

  // Spacing
  static double get spaceXS => 4.h;
  static double get spaceS => 8.h;
  static double get spaceM => 16.h;
  static double get spaceL => 24.h;
  static double get spaceXL => 32.h;
  static double get spaceXXL => 48.h;

  // App Bar
  static double get appBarHeight => 56.h;
  static double get appBarHeightLarge => 120.h;

  // Card
  static double get cardElevation => 2;
  static double get cardRadius => 12.r;
  static double get cardPadding => 16.w;

  // Bottom Navigation
  static double get bottomNavHeight => 60.h;

  // Image Sizes
  static double get imageXS => 40.w;
  static double get imageS => 60.w;
  static double get imageM => 80.w;
  static double get imageL => 120.w;
  static double get imageXL => 200.w;

  // Avatar Sizes
  static double get avatarS => 32.w;
  static double get avatarM => 48.w;
  static double get avatarL => 64.w;
  static double get avatarXL => 96.w;

  // Divider
  static double get dividerThickness => 1.h;

  // Loading Indicator
  static double get loadingSize => 40.w;
  static double get loadingStrokeWidth => 3.w;
}
