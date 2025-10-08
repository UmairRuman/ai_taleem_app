// lib/features/learning/presentation/screens/concept_quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/features/onboarding/presentation/providers/concepts_provider.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/quiz_question_widget.dart';
import '../widgets/quiz_result_widget.dart';

class ConceptQuizScreen extends ConsumerStatefulWidget {
  final String conceptId;

  const ConceptQuizScreen({super.key, required this.conceptId});

  @override
  ConsumerState<ConceptQuizScreen> createState() => _ConceptQuizScreenState();
}

class _ConceptQuizScreenState extends ConsumerState<ConceptQuizScreen>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {};
  bool _showResults = false;
  int _score = 0;

  late AnimationController _progressController;
  late AnimationController _questionController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Fetch concept
    Future.microtask(() {
      ref.read(conceptsProvider.notifier).getConcept(widget.conceptId);
    });
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _questionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.easeIn),
    );

    _progressController.forward();
    _questionController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _handleAnswer(String answer, String correctAnswer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });

    // Calculate score
    if (answer == correctAnswer) {
      _score++;
    }
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentQuestionIndex < totalQuestions - 1) {
      _questionController.reset();
      setState(() {
        _currentQuestionIndex++;
      });
      _questionController.forward();
    } else {
      setState(() {
        _showResults = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _questionController.reset();
      setState(() {
        _currentQuestionIndex--;
      });
      _questionController.forward();
    }
  }

  void _retakeQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers.clear();
      _score = 0;
      _showResults = false;
    });
    _questionController.reset();
    _questionController.forward();
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

  @override
  Widget build(BuildContext context) {
    final conceptState = ref.watch(conceptsProvider);

    return Scaffold(
      body:
          conceptState is ConceptsSingleLoadedState
              ? _buildQuizContent(conceptState.concept)
              : conceptState is ConceptsLoadingState
              ? _buildLoading()
              : _buildError(),
    );
  }

  Widget _buildQuizContent(Concept concept) {
    final gradeColor = _getGradeColor(concept.gradeLevel);
    final questions = concept.content.practiceQuiz ?? [];

    if (questions.isEmpty) {
      return _buildNoQuestions(gradeColor);
    }

    if (_showResults) {
      return QuizResultWidget(
        concept: concept,
        score: _score,
        totalQuestions: questions.length,
        gradeColor: gradeColor,
        onRetake: _retakeQuiz,
        onBack: () => context.pop(),
      );
    }

    final currentQuestion = questions[_currentQuestionIndex];

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
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(concept, gradeColor, questions.length),

                // Progress bar
                _buildProgressBar(questions.length, gradeColor),

                // Question
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: QuizQuestionWidget(
                        question: currentQuestion,
                        questionNumber: _currentQuestionIndex + 1,
                        totalQuestions: questions.length,
                        gradeColor: gradeColor,
                        selectedAnswer: _answers[_currentQuestionIndex],
                        onAnswerSelected:
                            (answer) => _handleAnswer(
                              answer,
                              currentQuestion['correct_answer'] ?? '',
                            ),
                      ),
                    ),
                  ),
                ),

                // Navigation buttons
                _buildNavigationButtons(questions.length, gradeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations(Color color) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Concept concept, Color gradeColor, int totalQuestions) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showExitDialog(context),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.textPrimary,
                  size: 24.w,
                ),
              ),
            ),
          ),

          SizedBox(width: AppDimensions.spaceM),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Practice Quiz', style: AppTextStyles.h4()),
                Text(
                  '${_currentQuestionIndex + 1} of $totalQuestions',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: gradeColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: gradeColor, size: 20.w),
                SizedBox(width: AppDimensions.spaceXS),
                Text('$_score', style: AppTextStyles.h5(color: gradeColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int totalQuestions, Color gradeColor) {
    final progress = (_currentQuestionIndex + 1) / totalQuestions;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      height: 8.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress * _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradeColor, gradeColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                boxShadow: [
                  BoxShadow(
                    color: gradeColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons(int totalQuestions, Color gradeColor) {
    final hasAnswer = _answers.containsKey(_currentQuestionIndex);
    final isLastQuestion = _currentQuestionIndex == totalQuestions - 1;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousQuestion,
                icon: Icon(Icons.arrow_back_rounded, size: 20.w),
                label: Text('Previous'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingM,
                  ),
                  side: BorderSide(color: gradeColor.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                ),
              ),
            ),

          if (_currentQuestionIndex > 0) SizedBox(width: AppDimensions.spaceM),

          // Next/Submit button
          Expanded(
            flex: _currentQuestionIndex > 0 ? 1 : 2,
            child: ElevatedButton.icon(
              onPressed: hasAnswer ? () => _nextQuestion(totalQuestions) : null,
              icon: Icon(
                isLastQuestion
                    ? Icons.check_rounded
                    : Icons.arrow_forward_rounded,
                size: 20.w,
              ),
              label: Text(isLastQuestion ? 'Submit' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: gradeColor,
                disabledBackgroundColor: AppColors.surfaceVariant,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuestions(Color gradeColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 64.w, color: AppColors.textTertiary),
          SizedBox(height: AppDimensions.spaceL),
          Text('No quiz available', style: AppTextStyles.h4()),
          SizedBox(height: AppDimensions.spaceL),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(backgroundColor: gradeColor),
          ),
        ],
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
          Text('Failed to load quiz', style: AppTextStyles.h4()),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            title: Text('Exit Quiz?', style: AppTextStyles.h4()),
            content: Text(
              'Your progress will be lost. Are you sure you want to exit?',
              style: AppTextStyles.bodyMedium(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: Text('Exit'),
              ),
            ],
          ),
    );
  }
}
