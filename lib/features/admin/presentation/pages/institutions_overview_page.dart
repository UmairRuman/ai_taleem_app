// Path: lib/features/government_panel/presentation/pages/institutions_overview_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';
import 'package:taleem_ai/features/admin/presentation/provider/institution_provider.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class InstitutionsOverviewPage extends ConsumerStatefulWidget {
  static const routeName = RouteNames.institutionsOverview;
  const InstitutionsOverviewPage({super.key});

  @override
  ConsumerState<InstitutionsOverviewPage> createState() =>
      _InstitutionsOverviewPageState();
}

class _InstitutionsOverviewPageState
    extends ConsumerState<InstitutionsOverviewPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(institutionProvider.notifier).getAllInstitutions();
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  List<Institution> _filterInstitutions(List<Institution> institutions) {
    var filtered = institutions;

    if (_selectedFilter == 'active') {
      filtered = filtered.where((i) => i.isActive).toList();
    } else if (_selectedFilter == 'inactive') {
      filtered = filtered.where((i) => !i.isActive).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (i) =>
                    i.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    i.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    i.code.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final institutionState = ref.watch(institutionProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.04),
                AppColors.background,
                AppColors.secondary.withOpacity(0.03),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background decorative elements
              // buildBackgroundDecorations(),

              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(institutionState),
                  SizedBox(height: AppDimensions.spaceL),

                  // Search and Filter Section
                  _buildSearchAndFilter(),
                  SizedBox(height: AppDimensions.spaceL),

                  // Summary Statistics
                  if (institutionState is InstitutionLoadedState)
                    _buildSummaryStats(institutionState.institutions),

                  SizedBox(height: AppDimensions.spaceL),

                  // Institutions List
                  Expanded(child: _buildInstitutionList(institutionState)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(InstitutionStates state) {
    int totalInstitutions = 0;
    if (state is InstitutionLoadedState) {
      totalInstitutions = state.institutions.length;
    }

    return FadeTransition(
      opacity: _fadeController.view,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.domain_rounded,
                    color: Colors.white,
                    size: 28.w,
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registered Institutions',
                        style: AppTextStyles.h3(),
                      ),
                      SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        'Government Dashboard • Monitoring $totalInstitutions institutions',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: AppDimensions.spaceM),
            // Container(
            //   padding: EdgeInsets.all(AppDimensions.paddingM),
            //   decoration: BoxDecoration(
            //     color: AppColors.primary.withOpacity(0.05),
            //     borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            //     border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            //   ),
            //   child: Text(
            //     'Track institutional performance, student engagement, and analytics across all schools. Monitor compliance, progress, and key metrics in real-time.',
            //     style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        children: [
          // Search Bar with enhanced styling
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search institutions by name, city, or code...',
                hintStyle: AppTextStyles.bodyMedium(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 24.w,
                ),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? GestureDetector(
                          onTap: () {
                            setState(() => _searchQuery = '');
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.textTertiary,
                            size: 20.w,
                          ),
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.all(AppDimensions.paddingM),
              ),
              style: AppTextStyles.bodyMedium(),
            ),
          ),

          SizedBox(height: AppDimensions.spaceM),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All',
                  value: 'all',
                  icon: Icons.all_inclusive_rounded,
                ),
                SizedBox(width: AppDimensions.spaceS),
                _buildFilterChip(
                  label: 'Active',
                  value: 'active',
                  icon: Icons.check_circle_rounded,
                ),
                SizedBox(width: AppDimensions.spaceS),
                _buildFilterChip(
                  label: 'Inactive',
                  value: 'inactive',
                  icon: Icons.cancel_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedFilter == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _selectedFilter = value);
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    )
                    : null,
            color: isSelected ? null : AppColors.surface,
            border: Border.all(
              color: isSelected ? Colors.transparent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 18.w,
              ),
              SizedBox(width: AppDimensions.spaceXS),
              Text(
                label,
                style: AppTextStyles.label(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStats(List<Institution> institutions) {
    final filtered = _filterInstitutions(institutions);
    final activeCount = filtered.where((i) => i.isActive).length;
    final totalStudents = filtered.fold<int>(
      0,
      (sum, i) => sum + i.totalStudents,
    );
    final totalTeachers = filtered.fold<int>(
      0,
      (sum, i) => sum + i.totalTeachers,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(_slideController),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.domain_rounded,
                label: 'Active',
                value: activeCount.toString(),
                color: AppColors.success,
              ),
            ),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: _buildStatCard(
                icon: Icons.school_rounded,
                label: 'Students',
                value: totalStudents.toString(),
                color: AppColors.secondary,
              ),
            ),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: _buildStatCard(
                icon: Icons.person_rounded,
                label: 'Teachers',
                value: totalTeachers.toString(),
                color: AppColors.info,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.w),
          SizedBox(height: AppDimensions.spaceXS),
          Text(value, style: AppTextStyles.h4(color: color)),
          SizedBox(height: AppDimensions.spaceXS),
          Text(
            label,
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionList(InstitutionStates state) {
    if (state is InstitutionLoadingState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              'Loading institutions...',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    } else if (state is InstitutionErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              'Error: ${state.error}',
              style: AppTextStyles.bodyMedium(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (state is InstitutionLoadedState) {
      final filtered = _filterInstitutions(state.institutions);

      if (filtered.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64.w,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: AppDimensions.spaceL),
              Text(
                _searchQuery.isEmpty
                    ? 'No institutions found'
                    : 'No institutions match your search',
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: _buildInstitutionCard(filtered[index]),
          );
        },
      );
    }

    return Center(
      child: Text(
        'Tap to load institutions',
        style: AppTextStyles.bodyMedium(color: AppColors.textDisabled),
      ),
    );
  }

  Widget _buildInstitutionCard(Institution institution) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'institutionDetail',
            pathParameters: {'id': institution.id},
            extra: institution,
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: Container(
          margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          institution.name.substring(0, 1).toUpperCase(),
                          style: AppTextStyles.h3(color: AppColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            institution.name,
                            style: AppTextStyles.h5(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppDimensions.spaceXS),
                          Row(
                            children: [
                              Text(
                                institution.code,
                                style: AppTextStyles.caption(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: AppDimensions.spaceS),
                              Container(
                                width: 1.w,
                                height: 12.h,
                                color: AppColors.border,
                              ),
                              SizedBox(width: AppDimensions.spaceS),
                              Icon(
                                institution.isActive
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color:
                                    institution.isActive
                                        ? AppColors.success
                                        : AppColors.error,
                                size: 16.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                institution.isActive ? 'Active' : 'Inactive',
                                style: AppTextStyles.caption(
                                  color:
                                      institution.isActive
                                          ? AppColors.success
                                          : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18.w,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spaceL),

                // Stats Row
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInlineStat(
                        icon: Icons.school_rounded,
                        label: 'Students',
                        value: institution.totalStudents.toString(),
                        color: AppColors.secondary,
                      ),
                      _buildInlineStat(
                        icon: Icons.person_rounded,
                        label: 'Teachers',
                        value: institution.totalTeachers.toString(),
                        color: AppColors.info,
                      ),
                      _buildInlineStat(
                        icon: Icons.family_restroom_rounded,
                        label: 'Parents',
                        value: institution.totalParents.toString(),
                        color: AppColors.primaryLight,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.spaceM),

                // Footer
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      institution.city,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      institution.type.capitalize(),
                      style: AppTextStyles.caption(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20.w),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.h5(color: color)),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.caption(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
