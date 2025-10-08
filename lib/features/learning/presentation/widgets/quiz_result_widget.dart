// lib/features/learning/presentation/widgets/quiz_result_widget.dart
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuizResultWidget extends StatefulWidget {
  final Concept concept;
  final int score;
  final int totalQuestions;
  final Color gradeColor;
  final VoidCallback onRetake;
  final VoidCallback onBack;

  const QuizResultWidget({
    super.key,
    required this.concept,
    required this.score,
    required this.totalQuestions,
    required this.gradeColor,
    required this.onRetake,
    required this.onBack,
  });

  @override
  State<QuizResultWidget> createState() => _QuizResultWidgetState();
}

class _QuizResultWidgetState extends State<QuizResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Show confetti if score is good
    if (_getPercentage() >= 70) {
      _confettiController.play();
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

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  double _getPercentage() {
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

  @override
  Widget build(BuildContext context) {
    final percentage = _getPercentage();
    final resultColor = _getResultColor();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            widget.gradeColor.withOpacity(0.05),
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
                            color: widget.gradeColor.withOpacity(0.3),
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
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${widget.score}',
                                  style: AppTextStyles.display1(
                                    color: widget.gradeColor,
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

                      SizedBox(height: AppDimensions.spaceXXL),

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
            onPressed: widget.onRetake,
            icon: Icon(Icons.refresh_rounded, size: 24.w),
            label: Text('Retake Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.gradeColor,
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              ),
            ),
          ),
        ),

        SizedBox(height: AppDimensions.spaceM),

        // Back button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: widget.onBack,
            icon: Icon(Icons.arrow_back_rounded, size: 24.w),
            label: Text('Back to Concept'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
              side: BorderSide(color: widget.gradeColor.withOpacity(0.3)),
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
