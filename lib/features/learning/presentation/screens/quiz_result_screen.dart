// lib/features/learning/presentation/screens/quiz_result_screen.dart
import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';
import 'package:taleem_ai/core/routes/route_names.dart';
import 'package:taleem_ai/features/onboarding/presentation/providers/concepts_provider.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final Concept concept;
  final int score;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.concept,
    required this.score,
    required this.totalQuestions,
  });

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;
  List<Concept> _prerequisiteConcepts = [];
  bool _isLoadingPrerequisites = false;
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Show confetti for completing quiz
    if (widget.score > 0) {
      _confettiController.play();
    }
    // Load prerequisites if they exist AND user didn't get perfect score
    if (widget.concept.prerequisites.isNotEmpty &&
        widget.score < widget.totalQuestions) {
      Future.microtask(() => _loadPrerequisites());
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  Future<void> _loadPrerequisites() async {
    if (_isLoadingPrerequisites) return;

    setState(() {
      _isLoadingPrerequisites = true;
    });

    try {
      final conceptsState = ref.read(conceptsProvider);
      List<Concept> allConcepts = [];

      if (conceptsState is ConceptsLoadedState) {
        allConcepts = conceptsState.concepts;
        log("Concepts already loaded: ${allConcepts.length}");
      } else {
        await ref.read(conceptsProvider.notifier).getAllConcepts();
        final newState = ref.read(conceptsProvider);
        if (newState is ConceptsLoadedState) {
          allConcepts = newState.concepts;
          log("Concepts loaded: ${allConcepts.length}");
        }
      }

      final prereqs = <Concept>[];

      for (final prereqId in widget.concept.prerequisites) {
        try {
          final prereqConcept = allConcepts.firstWhere(
            (c) => c.conceptId == prereqId,
          );
          log("Prerequisite found: ${prereqConcept.title}");
          prereqs.add(prereqConcept);
        } catch (e) {
          log("Prerequisite not found: $prereqId");
          continue;
        }
      }

      if (mounted) {
        setState(() {
          _prerequisiteConcepts = prereqs;
          _isLoadingPrerequisites = false;
        });

        // Auto-show dialog after loading if user got any question wrong
        if (prereqs.isNotEmpty &&
            !_hasShownDialog &&
            widget.score < widget.totalQuestions) {
          _hasShownDialog = true;
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              _showPrerequisitesDialog();
            }
          });
        }
      }
    } catch (e) {
      log("Error loading prerequisites: $e");
      if (mounted) {
        setState(() {
          _isLoadingPrerequisites = false;
        });
      }
    }
  }

  void _showPrerequisitesDialog() {
    if (!mounted || _prerequisiteConcepts.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: 600.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingXL),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _gradeColor.withOpacity(0.2),
                          _gradeColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimensions.radiusXXL),
                        topRight: Radius.circular(AppDimensions.radiusXXL),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          size: 64.w,
                          color: _gradeColor,
                        ),
                        SizedBox(height: AppDimensions.spaceL),
                        Text(
                          'Build Your Foundation!',
                          style: AppTextStyles.h3(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppDimensions.spaceM),
                        Text(
                          'These concepts will help you master ${widget.concept.title}',
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Prerequisites List
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        children: [
                          ..._prerequisiteConcepts.asMap().entries.map((entry) {
                            final index = entry.key;
                            final prereq = entry.value;
                            final tip = widget.concept.teacherRemediationTip
                                .cast<TeacherRemediationTip?>()
                                .firstWhere(
                                  (t) => t?.prerequisiteId == prereq.conceptId,
                                  orElse: () => null,
                                );

                            return _buildPrerequisiteCard(
                              prereq,
                              tip?.tip ??
                                  'Review the ${prereq.title} lesson from Grade ${prereq.gradeLevel}.',
                              index,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gradeColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusL,
                            ),
                          ),
                        ),
                        child: Text(
                          'Got it!',
                          style: AppTextStyles.button(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildPrerequisiteCard(Concept prereq, String tip, int index) {
    final prereqGradeColor = _getGradeColor(prereq.gradeLevel);

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context); // Close dialog
            context.pushNamed(
              'conceptDetail',
              pathParameters: {'conceptId': prereq.conceptId},
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: prereqGradeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTextStyles.h5(color: prereqGradeColor),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prereq.title, style: AppTextStyles.h6()),
                          SizedBox(height: AppDimensions.spaceS / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: prereqGradeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusS,
                              ),
                            ),
                            child: Text(
                              'Grade ${prereq.gradeLevel}',
                              style: AppTextStyles.caption(
                                color: prereqGradeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.w,
                      color: prereqGradeColor,
                    ),
                  ],
                ),
                if (tip.isNotEmpty) ...[
                  SizedBox(height: AppDimensions.spaceM),
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_rounded,
                          color: AppColors.info,
                          size: 18.w,
                        ),
                        SizedBox(width: AppDimensions.spaceS),
                        Expanded(
                          child: Text(
                            tip,
                            style: AppTextStyles.bodySmall(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  double _getPercentage() {
    if (widget.totalQuestions == 0) return 0;
    return (widget.score / widget.totalQuestions) * 100;
  }

  String _getResultMessage() {
    final percentage = _getPercentage();
    if (percentage >= 90) return 'Outstanding! 🌟';
    if (percentage >= 70) return 'Great Job! 🎉';
    if (percentage >= 50) return 'Good Effort! 💪';
    return 'Keep Practicing! 📚';
  }

  Color _getResultColor() {
    final percentage = _getPercentage();
    if (percentage >= 70) return AppColors.success;
    if (percentage >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Color get _gradeColor => _getGradeColor(widget.concept.gradeLevel);

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

  void _handleRetake() {
    // Pop result screen, then push quiz screen
    Navigator.of(context).pop();
    context.push('${RouteNames.conceptQuizScreen}/${widget.concept.conceptId}');
  }

  void _handleBackToConcept() {
    // Use GoRouter to navigate back to concept detail
    Navigator.of(context).pop();
    context.pushNamed(
      'conceptDetail',
      pathParameters: {'conceptId': widget.concept.conceptId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _getPercentage();
    final resultColor = _getResultColor();

    return WillPopScope(
      onWillPop: () async {
        _handleBackToConcept();
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                _gradeColor.withOpacity(0.05),
                AppColors.background,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  particleDrag: 0.05,
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  gravity: 0.1,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                ),
              ),

              // Content
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Result icon
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 150.w,
                              height: 150.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    resultColor.withOpacity(0.2),
                                    resultColor.withOpacity(0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  percentage >= 70
                                      ? Icons.emoji_events_rounded
                                      : percentage >= 50
                                      ? Icons.thumb_up_rounded
                                      : Icons.refresh_rounded,
                                  size: 80.w,
                                  color: resultColor,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: AppDimensions.spaceXL),

                          // Message
                          Text(
                            _getResultMessage(),
                            style: AppTextStyles.display1(),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: AppDimensions.spaceL),

                          // Score card
                          Container(
                            padding: EdgeInsets.all(AppDimensions.paddingXL),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXXL,
                              ),
                              border: Border.all(
                                color: _gradeColor.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Your Score',
                                  style: AppTextStyles.h4(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.spaceM),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${widget.score}',
                                      style: AppTextStyles.display1(
                                        color: _gradeColor,
                                      ),
                                    ),
                                    Text(
                                      '/${widget.totalQuestions}',
                                      style: AppTextStyles.h3(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppDimensions.spaceM),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingL,
                                    vertical: AppDimensions.paddingS,
                                  ),
                                  decoration: BoxDecoration(
                                    color: resultColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXL,
                                    ),
                                  ),
                                  child: Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: AppTextStyles.h3(color: resultColor),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: AppDimensions.spaceXL),

                          // Stats
                          _buildStats(),

                          SizedBox(height: AppDimensions.spaceXL),

                          // Show prerequisites button if available and user got any wrong
                          if (_prerequisiteConcepts.isNotEmpty &&
                              !_isLoadingPrerequisites &&
                              widget.score < widget.totalQuestions)
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                bottom: AppDimensions.spaceL,
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _showPrerequisitesDialog,
                                icon: Icon(Icons.school_rounded, size: 24.w),
                                label: const Text('View Related Concepts'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.info,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppDimensions.paddingL,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXL,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),

                          // Action buttons
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    final correct = widget.score;
    final incorrect = widget.totalQuestions - widget.score;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_rounded,
            label: 'Correct',
            value: '$correct',
            color: AppColors.success,
          ),
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _buildStatCard(
            icon: Icons.cancel_rounded,
            label: 'Incorrect',
            value: '$incorrect',
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.w),
          SizedBox(height: AppDimensions.spaceM),
          Text(value, style: AppTextStyles.h2(color: color)),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            label,
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Retake button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleRetake,
            icon: Icon(Icons.refresh_rounded, size: 24.w),
            label: const Text('Retake Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gradeColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              ),
              elevation: 0,
            ),
          ),
        ),

        SizedBox(height: AppDimensions.spaceM),

        // Back button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _handleBackToConcept,
            icon: Icon(Icons.arrow_back_rounded, size: 24.w),
            label: const Text('Back to Concept'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _gradeColor,
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
              side: BorderSide(color: _gradeColor.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
