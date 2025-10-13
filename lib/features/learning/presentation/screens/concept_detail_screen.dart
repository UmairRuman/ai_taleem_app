// lib/features/learning/presentation/screens/concept_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/routes/route_names.dart';
import 'package:taleem_ai/features/learning/presentation/screens/urdu_translation_screen.dart';
import 'package:taleem_ai/features/learning/presentation/widgets/content_section_widget.dart';
import 'package:taleem_ai/features/onboarding/presentation/providers/concepts_provider.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConceptDetailScreen extends ConsumerStatefulWidget {
  final String conceptId;

  const ConceptDetailScreen({super.key, required this.conceptId});

  @override
  ConsumerState<ConceptDetailScreen> createState() =>
      _ConceptDetailScreenState();
}

class _ConceptDetailScreenState extends ConsumerState<ConceptDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();

    // Fetch concept
    Future.microtask(() {
      ref.read(conceptsProvider.notifier).getConcept(widget.conceptId);
    });
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _headerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _contentController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_isHeaderCollapsed) {
        setState(() => _isHeaderCollapsed = true);
        _headerController.forward();
      } else if (_scrollController.offset <= 100 && _isHeaderCollapsed) {
        setState(() => _isHeaderCollapsed = false);
        _headerController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 6:
        return AppColors.grade6;
      case 7:
        return AppColors.grade7;
      case 8:
        return AppColors.grade8;
      default:
        return AppColors.primary;
    }
  }

  void _navigateToUrduTranslation(Concept concept, Color gradeColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => UrduTranslationScreen(
              conceptTitle: concept.title,
              gradeColor: gradeColor,
            ),
      ),
    );
  }

  void _showComingSoonDialog(String feature, IconData icon, Color color) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            ),
            child: Container(
              padding: EdgeInsets.all(AppDimensions.paddingXL),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.2),
                          color.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 48.w, color: color),
                  ),
                  SizedBox(height: AppDimensions.spaceL),
                  Text(
                    'Coming Soon!',
                    style: AppTextStyles.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: AppDimensions.spaceM),
                  Text(
                    '$feature feature will be available in the next version. Stay tuned for exciting updates!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceXL),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusL,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Got it',
                        style: AppTextStyles.button(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conceptState = ref.watch(conceptsProvider);

    return Scaffold(
      body:
          conceptState is ConceptsSingleLoadedState
              ? _buildContent(conceptState.concept)
              : conceptState is ConceptsLoadingState
              ? _buildLoading()
              : _buildError(),
    );
  }

  Widget _buildContent(Concept concept) {
    final gradeColor = _getGradeColor(concept.gradeLevel);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            gradeColor.withOpacity(0.05),
            AppColors.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background decorations
          _buildBackgroundDecorations(gradeColor),

          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Animated app bar
              _buildSliverAppBar(concept, gradeColor),

              // Content
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Hero section
                      _buildHeroSection(concept, gradeColor),

                      // Quick Action Cards (Translation & Tutorial)
                      _buildQuickActionCards(concept, gradeColor),

                      // Content sections
                      ContentSectionWidget(
                        concept: concept,
                        gradeColor: gradeColor,
                      ),
                      SizedBox(height: AppDimensions.spaceXL),

                      // Quiz button
                      if (concept.practiceQuiz.isNotEmpty)
                        _buildQuizButton(concept, gradeColor),

                      SizedBox(height: AppDimensions.spaceXXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards(Concept concept, Color gradeColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        children: [
          SizedBox(height: AppDimensions.spaceL),

          // Translation and Tutorial Cards
          Row(
            children: [
              // Translate to Urdu Card
              Expanded(
                child: _buildActionCard(
                  icon: Icons.translate_rounded,
                  title: 'اردو میں',
                  subtitle: 'Translate to Urdu',
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success.withOpacity(0.8),
                      AppColors.success.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => _navigateToUrduTranslation(concept, gradeColor),
                ),
              ),

              SizedBox(width: AppDimensions.spaceM),

              // Video Tutorial Card
              Expanded(
                child: _buildActionCard(
                  icon: Icons.play_circle_filled_rounded,
                  title: 'Tutorial',
                  subtitle: 'Watch Video',
                  gradient: LinearGradient(
                    colors: [
                      gradeColor.withOpacity(0.8),
                      gradeColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap:
                      () => _showComingSoonDialog(
                        'Video Tutorial',
                        Icons.play_circle_filled_rounded,
                        gradeColor,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spaceL),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 32.w),
                ),
                SizedBox(height: AppDimensions.spaceM),
                Text(
                  title,
                  style: AppTextStyles.h5(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  subtitle,
                  style: AppTextStyles.caption(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceS),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    'SOON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations(Color color) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Concept concept, Color gradeColor) {
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      backgroundColor: gradeColor,
      leading: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingS),
        child: Material(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: InkWell(
            onTap: () {
              ref
                  .read(conceptsProvider.notifier)
                  .getConceptsByGrade(concept.gradeLevel);
              context.pop();
            },
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.w,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedBuilder(
          animation: _headerAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: 1 - _headerAnimation.value,
              child: Text(
                concept.title,
                style: AppTextStyles.h5(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradeColor, gradeColor.withOpacity(0.8)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.school_rounded,
                    size: 150.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(Concept concept, Color gradeColor) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(concept.title, style: AppTextStyles.display2()),

          SizedBox(height: AppDimensions.spaceM),

          // Badges row
          Wrap(
            spacing: AppDimensions.spaceM,
            runSpacing: AppDimensions.spaceS,
            children: [
              _buildBadge(
                icon: Icons.class_rounded,
                label: 'Grade ${concept.gradeLevel}',
                color: gradeColor,
              ),
              _buildBadge(
                icon: Icons.topic_rounded,
                label: concept.topic,
                color: AppColors.secondary,
              ),
              _buildBadge(
                icon: Icons.access_time_rounded,
                label: '${concept.estimatedTimeMinutes} min',
                color: AppColors.info,
              ),
              _buildBadge(
                icon: _getDifficultyIcon(concept.difficulty),
                label: concept.difficulty,
                color: _getDifficultyColor(concept.difficulty),
              ),
            ],
          ),

          // Prerequisites
          if (concept.prerequisites.isNotEmpty) ...[
            SizedBox(height: AppDimensions.spaceL),
            _buildPrerequisitesSection(concept),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: color),
          SizedBox(width: AppDimensions.spaceXS),
          Text(label, style: AppTextStyles.caption(color: color)),
        ],
      ),
    );
  }

  Widget _buildPrerequisitesSection(Concept concept) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link_rounded, color: AppColors.warning, size: 20.w),
              SizedBox(width: AppDimensions.spaceS),
              Text(
                'Prerequisites Required',
                style: AppTextStyles.label(color: AppColors.warning),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          ...concept.prerequisites.map(
            (prereq) => Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16.w,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: Text(
                      prereq,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizButton(Concept concept, Color gradeColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              '${RouteNames.conceptQuizScreen}/${concept.conceptId}',
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradeColor, gradeColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: gradeColor.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_rounded, color: Colors.white, size: 28.w),
                SizedBox(width: AppDimensions.spaceM),
                Text(
                  'Take Practice Quiz',
                  style: AppTextStyles.h4(color: Colors.white),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64.w, color: AppColors.error),
          SizedBox(height: AppDimensions.spaceL),
          Text('Failed to load concept', style: AppTextStyles.h4()),
        ],
      ),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.sentiment_satisfied_rounded;
      case 'medium':
        return Icons.sentiment_neutral_rounded;
      case 'hard':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.easy;
      case 'medium':
        return AppColors.medium;
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.textSecondary;
    }
  }
}
