// lib/features/learning/presentation/widgets/quiz_question_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuizQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final int questionNumber;
  final int totalQuestions;
  final Color gradeColor;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const QuizQuestionWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.gradeColor,
    this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<QuizQuestionWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _feedbackController;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    widget.onAnswerSelected(answer);
    setState(() {
      _showFeedback = true;
    });
    _feedbackController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final questionType = widget.question['type'] ?? 'multiple_choice';

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.spaceL),

          // Question card
          _buildQuestionCard(),

          SizedBox(height: AppDimensions.spaceXL),

          // Answer options
          if (questionType == 'multiple_choice')
            _buildMultipleChoiceOptions()
          else if (questionType == 'fill_in_the_blank')
            _buildFillInBlank()
          else
            _buildShortAnswer(),

          // Feedback
          if (_showFeedback && widget.selectedAnswer != null) _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildShortAnswer() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Write your answer...',
          hintStyle: AppTextStyles.bodyMedium(color: AppColors.textTertiary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            borderSide: BorderSide(color: widget.gradeColor, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.all(AppDimensions.paddingM),
        ),
        onChanged: (value) => _selectAnswer(value),
        style: AppTextStyles.bodyLarge(),
        maxLines: 4,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(color: widget.gradeColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: widget.gradeColor.withOpacity(0.1),
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.gradeColor,
                      widget.gradeColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Text(
                  'Question ${widget.questionNumber}',
                  style: AppTextStyles.button(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            widget.question['question_text'] ?? '',
            style: AppTextStyles.h4(),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceOptions() {
    final options = widget.question['options'] as List? ?? [];

    return Column(
      children:
          options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value.toString();
            final isSelected = widget.selectedAnswer == option;
            final correctAnswer = widget.question['correct_answer'] ?? '';
            final isCorrect = option == correctAnswer;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: GestureDetector(
                onTap: () => _selectAnswer(option),
                child: Container(
                  margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
                  padding: EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? (isCorrect
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1))
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(
                      color:
                          isSelected
                              ? (isCorrect
                                  ? AppColors.success
                                  : AppColors.error)
                              : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: (isCorrect
                                        ? AppColors.success
                                        : AppColors.error)
                                    .withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? (isCorrect
                                      ? AppColors.success
                                      : AppColors.error)
                                  : widget.gradeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.transparent
                                    : widget.gradeColor.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child:
                              isSelected
                                  ? Icon(
                                    isCorrect
                                        ? Icons.check_rounded
                                        : Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20.w,
                                  )
                                  : Text(
                                    String.fromCharCode(65 + index),
                                    style: AppTextStyles.button(
                                      color: widget.gradeColor,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Text(
                          option,
                          style: AppTextStyles.bodyLarge(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildFillInBlank() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Type your answer here...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            borderSide: BorderSide(color: widget.gradeColor, width: 2),
          ),
        ),
        onChanged: (value) => _selectAnswer(value),
        style: AppTextStyles.bodyLarge(),
        maxLines: 4,
      ),
    );
  }

  Widget _buildFeedback() {
    final feedback = widget.question['feedback'] ?? 'Good job!';
    final isCorrect =
        widget.selectedAnswer == widget.question['correct_answer'];

    return FadeTransition(
      opacity: _feedbackController,
      child: Container(
        margin: EdgeInsets.only(top: AppDimensions.spaceXL),
        padding: EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color:
              isCorrect
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.info.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(
            color:
                isCorrect
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.info.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                  color: isCorrect ? AppColors.success : AppColors.info,
                  size: 24.w,
                ),
                SizedBox(width: AppDimensions.spaceM),
                Text(
                  isCorrect ? 'Correct!' : 'Feedback',
                  style: AppTextStyles.h5(
                    color: isCorrect ? AppColors.success : AppColors.info,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spaceM),
            Text(
              feedback,
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
