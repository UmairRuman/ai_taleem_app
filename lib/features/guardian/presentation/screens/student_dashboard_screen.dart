// lib/features/student/presentation/screens/student_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );

    _headerController.forward();
    _cardsController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  Future<void> _launchWebDashboard() async {
    final url = Uri.parse('https://taleemaidashboard.netlify.app');

    try {
      // Try to launch the URL
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Could not open dashboard. Please check your internet connection.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _launchWebDashboard,
            ),
          ),
        );
      }
    }
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
              AppColors.primary.withOpacity(0.05),
              AppColors.background,
              AppColors.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildSliverAppBar(),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingL),
                  child: Column(
                    children: [
                      // Hero Dashboard Card
                      _buildDashboardHeroCard(),

                      SizedBox(height: AppDimensions.spaceXL),

                      // Quick Actions
                      _buildQuickActions(),

                      SizedBox(height: AppDimensions.spaceXL),

                      // Features Grid
                      _buildFeaturesSection(),

                      SizedBox(height: AppDimensions.spaceXXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
          ),
          child: SlideTransition(
            position: _headerSlideAnimation,
            child: FadeTransition(
              opacity: _headerFadeAnimation,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.paddingL,
                  AppDimensions.paddingXL,
                  AppDimensions.paddingL,
                  AppDimensions.paddingM,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back! 👋',
                      style: AppTextStyles.h3(color: Colors.white),
                    ),
                    SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Let\'s continue your learning journey',
                      style: AppTextStyles.bodyMedium(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: AppDimensions.paddingM),
          child: IconButton(
            onPressed: () {
              // Logout functionality
            },
            icon: Icon(Icons.logout_rounded, color: Colors.white, size: 24.w),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardHeroCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _launchWebDashboard,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingXL),
              child: Column(
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.dashboard_rounded,
                      size: 64.w,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: AppDimensions.spaceL),

                  // Title
                  Text(
                    'Open Full Dashboard',
                    style: AppTextStyles.h3(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppDimensions.spaceM),

                  // Description
                  Text(
                    'Access your complete learning analytics, performance reports, and personalized recommendations',
                    style: AppTextStyles.bodyMedium(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppDimensions.spaceXL),

                  // Button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingXL,
                      vertical: AppDimensions.paddingM,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Launch Dashboard',
                          style: AppTextStyles.button(color: AppColors.primary),
                        ),
                        SizedBox(width: AppDimensions.spaceS),
                        Icon(
                          Icons.open_in_new_rounded,
                          color: AppColors.primary,
                          size: 20.w,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppDimensions.spaceM),

                  // Beta Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.web_rounded,
                          size: 16.w,
                          color: Colors.white,
                        ),
                        SizedBox(width: AppDimensions.spaceXS),
                        Text(
                          'Web-Based Dashboard',
                          style: AppTextStyles.caption(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.h4()),
        SizedBox(height: AppDimensions.spaceL),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.school_rounded,
                title: 'My Courses',
                color: AppColors.grade6,
                onTap: () {
                  context.push(RouteNames.courseContentListScreen);
                },
              ),
            ),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.search_rounded,
                title: 'Search',
                color: AppColors.grade7,
                onTap: () {
                  context.push(RouteNames.courseSearchScreen);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32.w),
                ),
                SizedBox(height: AppDimensions.spaceM),
                Text(
                  title,
                  style: AppTextStyles.label(color: color),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What You Get', style: AppTextStyles.h4()),
        SizedBox(height: AppDimensions.spaceL),
        _buildFeatureItem(
          icon: Icons.analytics_rounded,
          title: 'Performance Analytics',
          description: 'Track your progress with detailed insights and charts',
          color: AppColors.info,
          delay: 0,
        ),
        SizedBox(height: AppDimensions.spaceM),
        _buildFeatureItem(
          icon: Icons.quiz_rounded,
          title: 'Interactive Quizzes',
          description: 'Practice with adaptive quizzes and instant feedback',
          color: AppColors.secondary,
          delay: 100,
        ),
        SizedBox(height: AppDimensions.spaceM),
        _buildFeatureItem(
          icon: Icons.recommend_rounded,
          title: 'Smart Recommendations',
          description: 'Get personalized content based on your learning style',
          color: AppColors.success,
          delay: 200,
        ),
        SizedBox(height: AppDimensions.spaceM),
        _buildFeatureItem(
          icon: Icons.trending_up_rounded,
          title: 'Progress Tracking',
          description: 'Monitor your improvement across all subjects',
          color: AppColors.warning,
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Icon(icon, color: color, size: 28.w),
            ),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h5()),
                  SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
