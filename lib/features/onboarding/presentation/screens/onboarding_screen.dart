// lib/features/onboarding/presentation/screens/onboarding_screen.dart
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
import '../../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _iconAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.school_rounded,
      title: 'Personalized Learning',
      titleUrdu: 'ذاتی نوعیت کی تعلیم',
      description: 'Adaptive lessons tailored to your learning pace and style',
      descriptionUrdu: 'آپ کی سیکھنے کی رفتار کے مطابق سبق',
      color: AppColors.grade6,
    ),
    OnboardingPage(
      icon: Icons.psychology_rounded,
      title: 'Smart Recommendations',
      titleUrdu: 'ذہین تجاویز',
      description: 'AI-powered guidance to help you master difficult concepts',
      descriptionUrdu: 'مشکل تصورات میں مہارت حاصل کرنے کے لیے رہنمائی',
      color: AppColors.grade7,
    ),
    OnboardingPage(
      icon: Icons.insights_rounded,
      title: 'Track Your Progress',
      titleUrdu: 'اپنی ترقی کو ٹریک کریں',
      description: 'Monitor your learning journey with detailed analytics',
      descriptionUrdu: 'تفصیلی تجزیات کے ساتھ اپنے سیکھنے کا سفر دیکھیں',
      color: AppColors.grade8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    );

    _iconAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.isFirstLaunch, false);

    if (mounted) {
      context.go(RouteNames.roleSelection);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _iconAnimationController.reset();
    _fadeAnimationController.reset();
    _iconAnimationController.forward();
    _fadeAnimationController.forward();
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
              AppColors.background,
              AppColors.primaryLight.withOpacity(0.1),
              AppColors.background,
              AppColors.accent.withOpacity(0.05),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative geometric patterns - Educational theme
            Positioned(
              top: -50,
              right: -50,
              child: _buildDecorativeCircle(
                200,
                AppColors.primaryLight.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              left: -30,
              child: _buildDecorativeCircle(
                150,
                AppColors.accent.withOpacity(0.08),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -40,
              child: _buildDecorativeCircle(
                250,
                AppColors.secondaryLight.withOpacity(0.1),
              ),
            ),
            Positioned(
              bottom: 150,
              right: -60,
              child: _buildDecorativeCircle(
                180,
                AppColors.grade8.withOpacity(0.08),
              ),
            ),
            // Book/Education pattern elements
            Positioned(top: 200, right: 30, child: _buildBookIcon()),
            Positioned(bottom: 300, left: 40, child: _buildPencilIcon()),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTabletOrDesktop = constraints.maxWidth > 600;
                  final maxContentWidth =
                      isTabletOrDesktop ? 600.0 : constraints.maxWidth;

                  return Center(
                    child: Container(
                      width: maxContentWidth,
                      child: Column(
                        children: [
                          // Skip Button with fade-in animation
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Padding(
                              padding: EdgeInsets.all(AppDimensions.paddingM),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: _buildNeumorphicButton(
                                  onPressed: _skipOnboarding,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppDimensions.paddingM,
                                      vertical: AppDimensions.paddingS,
                                    ),
                                    child: Text(
                                      'Skip',
                                      style: AppTextStyles.button(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // PageView
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: _pages.length,
                              itemBuilder: (context, index) {
                                return _buildPage(_pages[index]);
                              },
                            ),
                          ),

                          // Page Indicators with animation
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.spaceM,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _pages.length,
                                (index) =>
                                    _buildIndicator(index == _currentPage),
                              ),
                            ),
                          ),

                          // Next/Get Started Button
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingL,
                            ),
                            child: _buildAnimatedButton(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppDimensions.spaceL),

            // Animated Icon with Neumorphic Container
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildNeumorphicIconContainer(page),
            ),

            SizedBox(height: AppDimensions.spaceXL * 1.5),

            // Title (English) with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2(),
              ),
            ),

            SizedBox(height: AppDimensions.spaceM),

            // Title (Urdu) with slide animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(_fadeAnimation),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  page.titleUrdu,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3(
                    color: AppColors.textSecondary,
                    isUrdu: true,
                  ),
                ),
              ),
            ),

            SizedBox(height: AppDimensions.spaceL),

            // Description Card with Neumorphic effect
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildDescriptionCard(page),
            ),

            SizedBox(height: AppDimensions.spaceL),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicIconContainer(OnboardingPage page) {
    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-6, -6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.grey.shade400.withOpacity(0.5),
            offset: const Offset(6, 6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [page.color.withOpacity(0.3), page.color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(page.icon, size: 64.w, color: page.color),
      ),
    );
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildBookIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.15,
          child: Transform.rotate(
            angle: -0.2,
            child: Transform.translate(
              offset: Offset(0, value * 10 - 5), // Floating animation
              child: Icon(
                Icons.menu_book_rounded,
                size: 60.w,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPencilIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.12,
          child: Transform.rotate(
            angle: 0.3,
            child: Transform.translate(
              offset: Offset(
                0,
                -value * 10 + 5,
              ), // Floating animation (opposite direction)
              child: Icon(
                Icons.edit_rounded,
                size: 50.w,
                color: AppColors.secondary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionCard(OnboardingPage page) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Container(
            height: 1,
            width: 60.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  page.color.withOpacity(0.0),
                  page.color.withOpacity(0.5),
                  page.color.withOpacity(0.0),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            page.descriptionUrdu,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(
              color: AppColors.textSecondary,
              isUrdu: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 32.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        gradient:
            isActive
                ? LinearGradient(
                  colors: [
                    _pages[_currentPage].color,
                    _pages[_currentPage].color.withOpacity(0.6),
                  ],
                )
                : null,
        color: isActive ? null : AppColors.textDisabled.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4.r),
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: _pages[_currentPage].color.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
                : null,
      ),
    );
  }

  Widget _buildAnimatedButton() {
    final isLastPage = _currentPage == _pages.length - 1;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: CustomButton(
            text: isLastPage ? 'Get Started' : 'Next',
            onPressed: _nextPage,
            icon: isLastPage ? Icons.arrow_forward_rounded : null,
          ),
        );
      },
    );
  }

  Widget _buildNeumorphicButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                offset: const Offset(-4, -4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String titleUrdu;
  final String description;
  final String descriptionUrdu;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.titleUrdu,
    required this.description,
    required this.descriptionUrdu,
    required this.color,
  });
}
