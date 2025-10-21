// Path: lib/features/government_panel/presentation/pages/institution_detail_page.dart
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class InstitutionDetailPage extends ConsumerStatefulWidget {
  static const routeName = '/admin-panel/institutions/:id';
  final Institution institution;

  const InstitutionDetailPage({super.key, required this.institution});

  @override
  ConsumerState<InstitutionDetailPage> createState() =>
      _InstitutionDetailPageState();
}

class _InstitutionDetailPageState extends ConsumerState<InstitutionDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final institution = widget.institution;

    // Generate analytics data
    final analyticsData = _generateAnalyticsData(institution);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Stack(
          children: [
            // Educational Background Pattern
            _buildEducationalBackground(),
            // Content
            CustomScrollView(
              slivers: [
                _buildAppBar(institution),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.paddingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusBanner(institution),
                            SizedBox(height: AppDimensions.spaceXL),
                            _buildQuickStatsRow(institution, analyticsData),
                            SizedBox(height: AppDimensions.spaceXL),
                            _buildSectionHeader(
                              'Performance Overview',
                              Icons.analytics_rounded,
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            _buildPerformanceCards(analyticsData),
                            SizedBox(height: AppDimensions.spaceXL),
                            _buildSectionHeader(
                              'User Engagement',
                              Icons.people_alt_rounded,
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            _buildEngagementMetrics(institution, analyticsData),
                            SizedBox(height: AppDimensions.spaceXL),
                            _buildSectionHeader(
                              'Learning Insights',
                              Icons.psychology_rounded,
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            _buildLearningInsights(analyticsData),
                            SizedBox(height: AppDimensions.spaceXL),
                            _buildSectionHeader(
                              'Areas Requiring Attention',
                              Icons.warning_amber_rounded,
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            _buildStrugglingConcepts(analyticsData),
                            SizedBox(height: AppDimensions.spaceXL),
                            _buildSectionHeader(
                              'Institution Information',
                              Icons.business_rounded,
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            _buildInstitutionDetails(institution),
                            SizedBox(height: AppDimensions.spaceXL),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Institution institution) {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          institution.name,
          style: AppTextStyles.h5(color: Colors.white),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h, right: 16.w),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(Institution institution) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              institution.isActive
                  ? [
                    AppColors.success.withOpacity(0.1),
                    AppColors.success.withOpacity(0.05),
                  ]
                  : [
                    AppColors.error.withOpacity(0.1),
                    AppColors.error.withOpacity(0.05),
                  ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color:
              institution.isActive
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.error.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: institution.isActive ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
            child: Icon(
              institution.isActive ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
              size: 24.w,
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institution.isActive
                      ? 'Active Institution'
                      : 'Inactive Institution',
                  style: AppTextStyles.h6(
                    color:
                        institution.isActive
                            ? AppColors.success
                            : AppColors.error,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Code: ${institution.code} • ${institution.type.capitalize()} • ${institution.city}',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow(
    Institution institution,
    Map<String, dynamic> analytics,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            icon: Icons.school_rounded,
            label: 'Students',
            value: institution.totalStudents.toString(),
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _buildQuickStatCard(
            icon: Icons.person_rounded,
            label: 'Teachers',
            value: institution.totalTeachers.toString(),
            color: AppColors.info,
          ),
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _buildQuickStatCard(
            icon: Icons.family_restroom_rounded,
            label: 'Parents',
            value: institution.totalParents.toString(),
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingM,
        horizontal: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28.w, color: color),
          SizedBox(height: 8.h),
          Text(value, style: AppTextStyles.h4(color: color)),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.caption(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Icon(icon, size: 20.w, color: AppColors.primary),
        ),
        SizedBox(width: AppDimensions.spaceS),
        Text(title, style: AppTextStyles.h5(color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildPerformanceCards(Map<String, dynamic> analytics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppDimensions.spaceM,
      mainAxisSpacing: AppDimensions.spaceM,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          icon: Icons.grade_rounded,
          title: 'Avg Quiz Score',
          value: '${analytics['avgQuizScore']}%',
          trend: '+2.5%',
          trendPositive: true,
          color: AppColors.warning,
        ),
        _buildMetricCard(
          icon: Icons.check_circle_rounded,
          title: 'Concept Mastery',
          value: '${analytics['conceptMasteryRate']}%',
          trend: '+5.3%',
          trendPositive: true,
          color: AppColors.success,
        ),
        _buildMetricCard(
          icon: Icons.menu_book_rounded,
          title: 'Lessons/Student',
          value: analytics['avgLessonsCompletedPerStudent'].toString(),
          trend: '+1.2',
          trendPositive: true,
          color: AppColors.secondaryDark,
        ),
        _buildMetricCard(
          icon: Icons.groups_rounded,
          title: 'Student:Teacher',
          value: '1:${analytics['studentTeacherRatio']}',
          trend: analytics['studentTeacherRatio'] > 20 ? 'High' : 'Optimal',
          trendPositive: analytics['studentTeacherRatio'] <= 20,
          color: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String trend,
    required bool trendPositive,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(icon, size: 24.w, color: color),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      trendPositive
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendPositive ? Icons.trending_up : Icons.trending_flat,
                      size: 12.w,
                      color:
                          trendPositive ? AppColors.success : AppColors.warning,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      trend,
                      style: AppTextStyles.caption(
                        color:
                            trendPositive
                                ? AppColors.success
                                : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTextStyles.h3(color: color),
                  maxLines: 1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementMetrics(
    Institution institution,
    Map<String, dynamic> analytics,
  ) {
    return Column(
      children: [
        _buildProgressIndicator(
          label: 'Active Users (Last 30 Days)',
          value: analytics['activeUsersLast30Days'],
          total:
              institution.totalStudents +
              institution.totalTeachers +
              institution.totalParents,
          color: AppColors.success,
          icon: Icons.people_alt_rounded,
        ),
        SizedBox(height: AppDimensions.spaceM),
        _buildProgressIndicator(
          label: 'Parent Engagement Rate',
          value:
              (analytics['parentEngagementRate'] *
                      institution.totalParents /
                      100)
                  .round(),
          total: institution.totalParents,
          color: AppColors.primaryLight,
          icon: Icons.connect_without_contact_rounded,
        ),
        SizedBox(height: AppDimensions.spaceM),
        _buildDailyLoginsCard(analytics['avgDailyLogins']),
      ],
    );
  }

  Widget _buildProgressIndicator({
    required String label,
    required int value,
    required int total,
    required Color color,
    required IconData icon,
  }) {
    final percentage = total > 0 ? (value / total * 100).clamp(0, 100) : 0.0;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.w, color: color),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
                ),
              ),
              Text(
                '$value / $total',
                style: AppTextStyles.bodyMedium(color: color),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8.h,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${percentage.toStringAsFixed(1)}% engagement',
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyLoginsCard(double avgDailyLogins) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(Icons.login_rounded, color: Colors.white, size: 28.w),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average Daily Logins',
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  avgDailyLogins.toStringAsFixed(1),
                  style: AppTextStyles.h3(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningInsights(Map<String, dynamic> analytics) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Performance Indicators',
            style: AppTextStyles.h6(color: AppColors.textPrimary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          _buildInsightRow(
            icon: Icons.trending_up,
            label: 'Concept Mastery Trend',
            value: '+5.3% this month',
            color: AppColors.success,
          ),
          _buildInsightRow(
            icon: Icons.access_time_rounded,
            label: 'Avg. Session Duration',
            value: '${analytics['avgSessionMinutes']} minutes',
            color: AppColors.info,
          ),
          _buildInsightRow(
            icon: Icons.emoji_events_rounded,
            label: 'Completion Rate',
            value: '${analytics['completionRate']}%',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(icon, size: 20.w, color: color),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: AppTextStyles.bodyMedium(color: color)),
        ],
      ),
    );
  }

  Widget _buildStrugglingConcepts(Map<String, dynamic> analytics) {
    final concepts =
        analytics['strugglingConcepts'] as List<Map<String, dynamic>>;

    return Column(
      children:
          concepts.asMap().entries.map((entry) {
            final index = entry.key;
            final concept = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
              child: _buildConceptCard(
                rank: index + 1,
                concept: concept['name'],
                studentCount: concept['studentCount'],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildConceptCard({
    required int rank,
    required String concept,
    required int studentCount,
  }) {
    Color rankColor;
    if (rank == 1) {
      rankColor = AppColors.error;
    } else if (rank == 2) {
      rankColor = AppColors.warning;
    } else {
      rankColor = AppColors.info;
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: rankColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(color: rankColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '#$rank',
                style: AppTextStyles.bodyMedium(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  concept,
                  style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 14.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$studentCount students struggling',
                      style: AppTextStyles.caption(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.warning_amber_rounded, color: rankColor, size: 24.w),
        ],
      ),
    );
  }

  // Widget _buildEducationalBackground() {
  //   return Positioned.fill(
  //     child: Container(
  //       color: Colors.red, // Add this temporarily to test
  //       child: CustomPaint(painter: EducationalBackgroundPainter()),
  //     ),
  //   );
  // }

  Widget _buildInstitutionDetails(Institution institution) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('Institution ID', institution.id),
          _buildDetailRow('Code', institution.code),
          _buildDetailRow('Type', institution.type.capitalize()),
          _buildDetailRow('City', institution.city),
          _buildDetailRow('Address', institution.address ?? 'Not provided'),
          _buildDetailRow('Owner ID', institution.ownerId),
          _buildDetailRow(
            'Created',
            DateFormat('MMM d, yyyy').format(institution.createdAt),
          ),
          _buildDetailRow(
            'Last Updated',
            DateFormat('MMM d, yyyy').format(institution.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _generateAnalyticsData(Institution institution) {
    final Random random = Random();

    final int totalUsers =
        institution.totalStudents +
        institution.totalTeachers +
        institution.totalParents;

    final strugglingConcepts = [
      {'name': 'De Morgan\'s Laws', 'studentCount': random.nextInt(15) + 5},
      {'name': 'Power Sets', 'studentCount': random.nextInt(12) + 4},
      {'name': 'Set Operations', 'studentCount': random.nextInt(10) + 3},
    ];

    return {
      'activeUsersLast30Days':
          random.nextInt(totalUsers) + (totalUsers * 0.6).toInt(),
      'avgDailyLogins': double.parse(
        (random.nextDouble() * 5 + 1).toStringAsFixed(1),
      ),
      'avgLessonsCompletedPerStudent': double.parse(
        (random.nextDouble() * 10 + 5).toStringAsFixed(1),
      ),
      'avgQuizScore': double.parse(
        (random.nextDouble() * 20 + 70).toStringAsFixed(1),
      ),
      'conceptMasteryRate': double.parse(
        (random.nextDouble() * 25 + 65).toStringAsFixed(1),
      ),
      'studentTeacherRatio': random.nextInt(10) + 15,
      'parentEngagementRate': double.parse(
        (random.nextDouble() * 50).toStringAsFixed(1),
      ),
      'strugglingConcepts': strugglingConcepts,
      'avgSessionMinutes': random.nextInt(30) + 15,
      'completionRate': random.nextInt(30) + 60,
    };
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Widget _buildEducationalBackground() {
  return Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.03),
            AppColors.secondary.withOpacity(0.02),
            AppColors.background,
          ],
        ),
      ),
      child: CustomPaint(painter: EducationalBackgroundPainter()),
    ),
  );
}

// Custom Painter for Educational Background
class EducationalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid pattern first
    _drawGridPattern(canvas, size);
    // Draw math symbols on top
    _drawMathSymbols(canvas, size);
  }

  void _drawMathSymbols(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr, // Add this!
    );

    // Mathematical symbols
    final symbols = [
      '∪',
      '∩',
      '⊆',
      '⊂',
      '∈',
      '∅',
      'π',
      '∑',
      '∞',
      '√',
      '∫',
      'Δ',
    ];
    final random = Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbol = symbols[random.nextInt(symbols.length)];
      final opacity = 0.08 + random.nextDouble() * 0.07; // Increased opacity

      textPainter.text = TextSpan(
        text: symbol,
        style: TextStyle(
          fontSize: 40 + random.nextDouble() * 30,
          color: AppColors.primary.withOpacity(opacity),
          fontWeight: FontWeight.w300,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  void _drawGridPattern(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = AppColors.primary.withOpacity(0.05); // Increased opacity

    // Draw subtle diagonal lines
    for (double i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
