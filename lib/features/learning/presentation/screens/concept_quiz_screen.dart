// lib/features/learning/presentation/screens/concept_quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart';
import 'package:taleem_ai/features/onboarding/presentation/providers/concepts_provider.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
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

  void _handleAnswer(String answer, PracticeQuiz question) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });

    // Calculate score
    if (answer == question.correctAnswer) {
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
    final questions = concept.practiceQuiz;

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
                            (answer) => _handleAnswer(answer, currentQuestion),
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

  Widget _buildBackgroundDecorations(Color gradeColor) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [gradeColor.withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [gradeColor.withOpacity(0.05), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Concept concept, Color gradeColor, int totalQuestions) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  concept.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalQuestions Questions',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int totalQuestions, Color gradeColor) {
    final progress = (_currentQuestionIndex + 1) / totalQuestions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of $totalQuestions',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: gradeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(int totalQuestions, Color gradeColor) {
    final hasAnswer = _answers.containsKey(_currentQuestionIndex);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousQuestion,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: gradeColor),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (_currentQuestionIndex > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: hasAnswer ? () => _nextQuestion(totalQuestions) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: gradeColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                _currentQuestionIndex < totalQuestions - 1
                    ? 'Next Question'
                    : 'Finish Quiz',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
          Icon(
            Icons.quiz_rounded,
            size: 80,
            color: gradeColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No questions available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This concept doesn\'t have any quiz questions yet',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
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
          const Icon(Icons.error_outline_rounded, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load quiz',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
