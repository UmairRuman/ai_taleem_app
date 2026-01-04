// lib/features/onboarding/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rippleController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToNext();
  }

  void _initializeAnimations() {
    // Main animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Ripple effect controller
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Particle animation controller
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(StorageKeys.isFirstLaunch) ?? true;
    final authToken = prefs.getString(StorageKeys.authToken);

    if (isFirstLaunch) {
      context.go(RouteNames.onboarding);
    } else if (authToken == null || authToken.isEmpty) {
      context.go(RouteNames.onboarding);
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _rippleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.accent,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background patterns
            _buildBackgroundPatterns(),

            // Main content
            SafeArea(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTabletOrDesktop = constraints.maxWidth > 600;
                    final maxContentWidth =
                        isTabletOrDesktop ? 500.0 : constraints.maxWidth;

                    return SizedBox(
                      width: maxContentWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Spacer(flex: 2),
                          SizedBox(height: AppDimensions.spaceXL),

                          // Animated Logo with Ripple Effect
                          _buildAnimatedLogo(),

                          SizedBox(height: AppDimensions.spaceXL),

                          // App Name with slide animation
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _slideAnimation.value),
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    children: [
                                      // App Name with shine effect
                                      ShaderMask(
                                        shaderCallback: (bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white.withOpacity(0.8),
                                              Colors.white,
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                          ).createShader(bounds);
                                        },
                                        child: Text(
                                          AppConstants.appName,
                                          style: AppTextStyles.display1(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      SizedBox(height: AppDimensions.spaceS),

                                      // Urdu Name
                                      Text(
                                        ' اِسمارْٹ  تعلیم',
                                        style: AppTextStyles.h3(
                                          color: Colors.white.withOpacity(0.95),
                                          isUrdu: true,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      SizedBox(height: AppDimensions.spaceM),

                                      // Tagline in English
                                      Text(
                                        'Smart Learning, Brighter Future',
                                        style: AppTextStyles.bodyLarge(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      SizedBox(height: AppDimensions.spaceS),

                                      // Tagline in Urdu
                                      Text(
                                        'ذہین تعلیم، روشن مستقبل',
                                        style: AppTextStyles.bodyMedium(
                                          color: Colors.white.withOpacity(0.85),
                                          isUrdu: true,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // const Spacer(flex: 2),
                          SizedBox(height: AppDimensions.spaceXXL),

                          // Government Badge
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildGovernmentBadge(),
                          ),

                          SizedBox(height: AppDimensions.spaceL),

                          // Loading Indicator with custom design
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildLoadingIndicator(),
                          ),

                          SizedBox(height: AppDimensions.paddingXL),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPatterns() {
    return Stack(
      children: [
        // Top-right decorative circles
        Positioned(
          top: -100,
          right: -100,
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.1,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom-left decorative circles
        Positioned(
          bottom: -80,
          left: -80,
          child: Opacity(
            opacity: 0.08,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
        // Educational icons scattered
        Positioned(
          top: 100,
          right: 50,
          child: _buildFloatingIcon(Icons.menu_book_rounded, 0.0),
        ),
        Positioned(
          bottom: 150,
          left: 40,
          child: _buildFloatingIcon(Icons.lightbulb_outline, 0.5),
        ),
        Positioned(
          top: 200,
          left: 60,
          child: _buildFloatingIcon(Icons.stars_rounded, 1.0),
        ),
      ],
    );
  }

  Widget _buildFloatingIcon(IconData icon, double delay) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final value = (_particleController.value + delay) % 1.0;
        return Transform.translate(
          offset: Offset(0, value * 20 - 10),
          child: Opacity(
            opacity: 0.15,
            child: Icon(icon, size: 40.w, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple effects
        ...List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              final delay = index * 0.3;
              final value = (_rippleController.value + delay) % 1.0;
              return Opacity(
                opacity: 1.0 - value,
                child: Container(
                  width: 150.w + (value * 80),
                  height: 150.w + (value * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              );
            },
          );
        }),

        // Main logo container
        FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.school_rounded,
                    size: 80.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGovernmentBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 20.w, color: Colors.white),
          SizedBox(width: AppDimensions.spaceS),
          Text(
            'Government Approved Initiative',
            style: AppTextStyles.labelSmall(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 40.w,
          height: 40.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.9),
            ),
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ),
        SizedBox(height: AppDimensions.spaceM),
        Text(
          'Initializing...',
          style: AppTextStyles.caption(color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}
