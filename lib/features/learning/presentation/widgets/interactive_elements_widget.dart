// lib/features/learning/presentation/widgets/interactive_elements_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class InteractiveElementsWidget extends StatelessWidget {
  final List<dynamic> interactiveElements;
  final Color gradeColor;

  const InteractiveElementsWidget({
    super.key,
    required this.interactiveElements,
    required this.gradeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (interactiveElements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.spaceXL),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          child: Row(
            children: [
              Icon(Icons.extension_rounded, color: gradeColor, size: 28.w),
              SizedBox(width: AppDimensions.spaceM),
              Text(
                'Interactive Challenges',
                style: AppTextStyles.h3(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spaceL),
        ...interactiveElements.map(
          (element) => _buildElement(context, element),
        ),
      ],
    );
  }

  Widget _buildElement(BuildContext context, dynamic element) {
    final type = element['type'] as String?;

    switch (type) {
      case 'Challenge':
        return _ChallengeElement(element: element, gradeColor: gradeColor);
      case 'ThinkingPrompt':
        return _ThinkingPromptElement(element: element, gradeColor: gradeColor);
      case 'AITutorChallenge':
        return _AITutorChallengeElement(
          element: element,
          gradeColor: gradeColor,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ==================== Challenge Element ====================
class _ChallengeElement extends StatefulWidget {
  final Map<String, dynamic> element;
  final Color gradeColor;

  const _ChallengeElement({required this.element, required this.gradeColor});

  @override
  State<_ChallengeElement> createState() => _ChallengeElementState();
}

class _ChallengeElementState extends State<_ChallengeElement> {
  final TextEditingController _answerController = TextEditingController();
  bool _showHint = false;
  bool _isAnswered = false;
  String? _feedback;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final quiz = widget.element['quiz'] as Map<String, dynamic>?;
    if (quiz == null) return;

    final correctAnswer = quiz['correct_answer'] as String?;
    final userAnswer = _answerController.text.trim();

    setState(() {
      _isAnswered = true;
      if (correctAnswer != null &&
          userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
        _feedback = '✅ Correct! Well done!';
      } else {
        _feedback = '❌ Not quite. Try again or check the hint.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.element['title'] as String? ?? 'Challenge';
    final content = widget.element['content'] as String? ?? '';
    final quiz = widget.element['quiz'] as Map<String, dynamic>?;
    final steps = widget.element['steps'] as List<dynamic>?;
    final hint = widget.element['hint'] as String?;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.spaceM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.gradeColor.withOpacity(0.1),
            widget.gradeColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(color: widget.gradeColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: widget.gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusXXL),
                topRight: Radius.circular(AppDimensions.radiusXXL),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: widget.gradeColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: widget.gradeColor,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h4(color: widget.gradeColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: widget.gradeColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Text(
                    'CHALLENGE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
                ),

                // Steps (if present)
                if (steps != null && steps.isNotEmpty) ...[
                  SizedBox(height: AppDimensions.spaceL),
                  Text(
                    'Follow these steps:',
                    style: AppTextStyles.label(color: widget.gradeColor),
                  ),
                  SizedBox(height: AppDimensions.spaceM),
                  ...steps.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: widget.gradeColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: AppTextStyles.caption(
                                  color: widget.gradeColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: Text(
                              entry.value.toString(),
                              style: AppTextStyles.bodyMedium(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                // Quiz (if present)
                if (quiz != null) ...[
                  SizedBox(height: AppDimensions.spaceL),
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz['question_text'] as String? ?? '',
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppDimensions.spaceM),
                        TextField(
                          controller: _answerController,
                          decoration: InputDecoration(
                            hintText: 'Type your answer here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                              borderSide: BorderSide(
                                color: widget.gradeColor,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _checkAnswer(),
                        ),
                        SizedBox(height: AppDimensions.spaceM),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkAnswer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.gradeColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingM,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusM,
                                ),
                              ),
                            ),
                            child: Text('Check Answer'),
                          ),
                        ),
                        if (_isAnswered && _feedback != null) ...[
                          SizedBox(height: AppDimensions.spaceM),
                          Container(
                            padding: EdgeInsets.all(AppDimensions.paddingM),
                            decoration: BoxDecoration(
                              color:
                                  _feedback!.startsWith('✅')
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                            ),
                            child: Text(
                              _feedback!,
                              style: AppTextStyles.bodyMedium(
                                color:
                                    _feedback!.startsWith('✅')
                                        ? AppColors.success
                                        : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Hint Button (if present)
                if (hint != null) ...[
                  SizedBox(height: AppDimensions.spaceL),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _showHint = !_showHint),
                    icon: Icon(
                      _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                      size: 20.w,
                    ),
                    label: Text(_showHint ? 'Hide Hint' : 'Show Hint'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.gradeColor,
                      side: BorderSide(color: widget.gradeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                    ),
                  ),
                  if (_showHint) ...[
                    SizedBox(height: AppDimensions.spaceM),
                    Container(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.tips_and_updates_rounded,
                            color: AppColors.warning,
                            size: 20.w,
                          ),
                          SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: Text(
                              hint,
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Thinking Prompt Element ====================
class _ThinkingPromptElement extends StatefulWidget {
  final Map<String, dynamic> element;
  final Color gradeColor;

  const _ThinkingPromptElement({
    required this.element,
    required this.gradeColor,
  });

  @override
  State<_ThinkingPromptElement> createState() => _ThinkingPromptElementState();
}

class _ThinkingPromptElementState extends State<_ThinkingPromptElement> {
  final TextEditingController _reflectionController = TextEditingController();
  bool _isSaved = false;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _saveReflection() {
    if (_reflectionController.text.trim().isEmpty) return;
    setState(() => _isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('💭 Your reflection has been saved!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.element['question'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.spaceM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.info.withOpacity(0.1),
            AppColors.info.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusXXL),
                topRight: Radius.circular(AppDimensions.radiusXXL),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology_rounded,
                    color: AppColors.info,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    'Thinking Prompt',
                    style: AppTextStyles.h4(color: AppColors.info),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Text(
                    'META-SKILL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
                ),
                SizedBox(height: AppDimensions.spaceL),
                TextField(
                  controller: _reflectionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                      borderSide: BorderSide(color: AppColors.info, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceM),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveReflection,
                    icon: Icon(
                      _isSaved ? Icons.check_rounded : Icons.save_rounded,
                    ),
                    label: Text(_isSaved ? 'Saved!' : 'Save Reflection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSaved ? AppColors.success : AppColors.info,
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
                  ),
                ),
                SizedBox(height: AppDimensions.spaceS),
                Text(
                  '💡 In future versions, AI will analyze your reflection and provide personalized feedback!',
                  style: AppTextStyles.caption(color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== AI Tutor Challenge Element ====================
class _AITutorChallengeElement extends StatefulWidget {
  final Map<String, dynamic> element;
  final Color gradeColor;

  const _AITutorChallengeElement({
    required this.element,
    required this.gradeColor,
  });

  @override
  State<_AITutorChallengeElement> createState() =>
      _AITutorChallengeElementState();
}

class _AITutorChallengeElementState extends State<_AITutorChallengeElement> {
  String? _selectedPrompt;
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    final scenario = widget.element['scenario'] as String? ?? '';
    final prompts = widget.element['prompts'] as Map<String, dynamic>? ?? {};
    final explanation = widget.element['explanation'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.spaceM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusXXL),
                topRight: Radius.circular(AppDimensions.radiusXXL),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: AppColors.secondary,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    'AI Tutor Challenge',
                    style: AppTextStyles.h4(color: AppColors.secondary),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Text(
                    'AI LITERACY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scenario,
                  style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
                ),
                SizedBox(height: AppDimensions.spaceL),
                Text(
                  'Which prompt would you use?',
                  style: AppTextStyles.label(color: AppColors.secondary),
                ),
                SizedBox(height: AppDimensions.spaceM),

                // Prompt Options
                ...prompts.entries.map((entry) {
                  final isSelected = _selectedPrompt == entry.key;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPrompt = entry.key;
                        _showExplanation = true;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.secondary.withOpacity(0.1)
                                : AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.secondary
                                  : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.secondary
                                      : AppColors.border,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                entry.key.toUpperCase()[0],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: Text(
                              entry.value.toString(),
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Explanation
                if (_showExplanation) ...[
                  SizedBox(height: AppDimensions.spaceL),
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: AppColors.success,
                              size: 20.w,
                            ),
                            SizedBox(width: AppDimensions.spaceS),
                            Text(
                              'Explanation',
                              style: AppTextStyles.label(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.spaceM),
                        Text(
                          explanation,
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
