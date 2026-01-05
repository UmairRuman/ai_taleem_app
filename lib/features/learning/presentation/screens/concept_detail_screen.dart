// lib/features/learning/presentation/screens/concept_detail_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/providers/concepts_provider.dart';
import 'package:taleem_ai/core/providers/language_provider.dart';
import 'package:taleem_ai/core/routes/route_names.dart';
import 'package:taleem_ai/features/learning/presentation/widgets/content_section_widget.dart';
import 'package:taleem_ai/features/learning/presentation/widgets/interactive_elements_widget.dart';
import '../../../../core/domain/entities/concept.dart';
import '../../../../core/domain/entities/concept_content.dart';
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
  late AnimationController _fabController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();

    // NEW: Fetch concept with content in current language
    Future.microtask(() {
      final currentLang = ref.read(languageProvider).languageCode;
      ref.read(conceptsProvider.notifier).getConcept(widget.conceptId, currentLang);
    });

    // Delay FAB appearance
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showFab = true);
        _fabController.forward();
      }
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

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));

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
    _fabController.dispose();
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

  // NEW: Toggle language with lazy content loading
  void _toggleLanguage(Concept currentConcept) {
    final currentLang = ref.read(languageProvider);
    final newLang = currentLang.languageCode == 'en' ? 'ur' : 'en';

    // Animate the rotation
    _fabController.reset();
    _fabController.forward();

    // Toggle language
    ref.read(languageProvider.notifier).toggleLanguage();

    // NEW: Lazy load content if not already loaded
    if (!currentConcept.hasContentLoaded(newLang)) {
      ref.read(conceptsProvider.notifier).loadConceptContent(currentConcept, newLang);
    }

    // Show snackbar with animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              newLang == 'ur' ? Icons.translate : Icons.language,
              color: Colors.white,
            ),
            SizedBox(width: AppDimensions.spaceM),
            Text(
              newLang == 'ur'
                  ? 'اردو میں تبدیل ہو گیا'
                  : 'Switched to English',
              style: AppTextStyles.bodyMedium(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showComingSoonDialog(String feature, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
    final languageState = ref.watch(languageProvider);
    final conceptState = ref.watch(conceptsProvider);

    return Scaffold(
      body: conceptState is ConceptsSingleLoadedState
          ? _buildContent(conceptState.concept, languageState.languageCode)
          : conceptState is ConceptsLoadingState
              ? _buildLoading()
              : _buildError(),
      floatingActionButton: conceptState is ConceptsSingleLoadedState
          ? _buildLanguageToggleFAB(languageState.languageCode, conceptState.concept)
          : null,
    );
  }

  // NEW: Pass concept for lazy loading
  Widget _buildLanguageToggleFAB(String currentLanguage, Concept concept) {
    return AnimatedBuilder(
      animation: _fabScaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _fabScaleAnimation.value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _toggleLanguage(concept),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _fabRotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _fabRotationAnimation.value * 3.14159 * 2,
                        child: child,
                      );
                    },
                    child: Icon(
                      currentLanguage == 'en'
                          ? Icons.translate_rounded
                          : Icons.language_rounded,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceS),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      currentLanguage == 'en' ? 'اردو' : 'English',
                      key: ValueKey(currentLanguage),
                      style: AppTextStyles.button(color: Colors.white),
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

  // NEW: Updated to use Concept and ConceptContent
  Widget _buildContent(Concept concept, String languageCode) {
    final content = concept.getContent(languageCode);
    
    // Show loading if content not yet loaded for this language
    if (content == null) {
      return _buildLoading();
    }

    log("Concept Image path: ${content.images.toString()}");
    final gradeColor = _getGradeColor(concept.metadata.gradeLevel);

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
          _buildBackgroundDecorations(gradeColor),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(concept, content, gradeColor),
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildHeroSection(concept, content, gradeColor),
                      _buildTutorialCard(gradeColor),
                      ContentSectionWidget(
                        languageState: languageCode,
                        conceptImages: content.images,
                        content: content,
                        metadata: concept.metadata,
                        gradeColor: gradeColor,
                      ),
                      SizedBox(height: AppDimensions.spaceXL),
                      InteractiveElementsWidget(
                        interactiveElements: content.interactiveElements,
                        gradeColor: gradeColor,
                      ),
                      if (content.practiceQuiz.isNotEmpty)
                        _buildQuizButton(concept, content, gradeColor),
                      SizedBox(height: AppDimensions.spaceXXL * 2),
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

  Widget _buildTutorialCard(Color gradeColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.spaceL,
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.9 + (0.1 * value),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showComingSoonDialog(
              'Video Tutorial',
              Icons.play_circle_filled_rounded,
              gradeColor,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradeColor.withOpacity(0.9),
                    gradeColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: gradeColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_circle_filled_rounded,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video Tutorial',
                          style: AppTextStyles.h4(color: Colors.white),
                        ),
                        SizedBox(height: AppDimensions.spaceXS),
                        Text(
                          'Watch step-by-step explanation',
                          style: AppTextStyles.bodySmall(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'SOON',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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

  // NEW: Updated to use Concept and ConceptContent
  Widget _buildSliverAppBar(
    Concept concept,
    ConceptContent content,
    Color gradeColor,
  ) {
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
              log("Grade level: ${concept.metadata.gradeLevel}");
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
                content.title,
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

  // NEW: Updated to use Concept and ConceptContent
  Widget _buildHeroSection(
    Concept concept,
    ConceptContent content,
    Color gradeColor,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content.title, style: AppTextStyles.display2()),
          SizedBox(height: AppDimensions.spaceM),
          Wrap(
            spacing: AppDimensions.spaceM,
            runSpacing: AppDimensions.spaceS,
            children: [
              _buildBadge(
                icon: Icons.class_rounded,
                label: 'Grade ${concept.metadata.gradeLevel}',
                color: gradeColor,
              ),
              _buildBadge(
                icon: Icons.topic_rounded,
                label: concept.metadata.topic,
                color: AppColors.secondary,
              ),
              _buildBadge(
                icon: Icons.access_time_rounded,
                label: '${concept.metadata.estimatedTimeMinutes} min',
                color: AppColors.info,
              ),
              _buildBadge(
                icon: _getDifficultyIcon(concept.metadata.difficultyLevel),
                label: concept.metadata.difficultyLevel,
                color: _getDifficultyColor(concept.metadata.difficultyLevel),
              ),
            ],
          ),
          if (concept.metadata.hasPrerequisites) ...[
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
          ...concept.metadata.prerequisites.map(
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

  Widget _buildQuizButton(Concept concept, ConceptContent content, Color gradeColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              '${RouteNames.conceptQuizScreen}/${concept.metadata.conceptId}',
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
          SizedBox(height: AppDimensions.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              final currentLang = ref.read(languageProvider).languageCode;
              ref.read(conceptsProvider.notifier).getConcept(widget.conceptId, currentLang);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'basic':
      case 'easy':
        return Icons.sentiment_satisfied_rounded;
      case 'intermediate':
      case 'medium':
        return Icons.sentiment_neutral_rounded;
      case 'advanced':
      case 'hard':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'basic':
      case 'easy':
        return AppColors.easy;
      case 'intermediate':
      case 'medium':
        return AppColors.medium;
      case 'advanced':
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.textSecondary;
    }
  }
}