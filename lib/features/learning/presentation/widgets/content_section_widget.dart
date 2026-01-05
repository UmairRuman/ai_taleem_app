// lib/features/learning/presentation/widgets/content_section_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taleem_ai/core/domain/entities/common_mistake.dart';
import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';
import 'package:taleem_ai/core/domain/entities/concept_example.dart';

// NEW: Import new entities

import '../../../../core/domain/entities/concept_content.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ContentSectionWidget extends StatelessWidget {
  // NEW: Separate metadata and content
  final ConceptMetadata metadata;
  final ConceptContent content;
  final Color gradeColor;
  final List<String> conceptImages;
  final String languageState;

  const ContentSectionWidget({
    super.key,
    required this.languageState,
    required this.metadata,
    required this.content,
    required this.gradeColor,
    required this.conceptImages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          if (content.content.introduction.isNotEmpty)
            _buildSection(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Introduction',
              child: _buildTextContent(content.content.introduction),
            ),

          // Concept Image Section
          if (conceptImages.isNotEmpty)
            _buildConceptImage(conceptImages.first, gradeColor),

          // Definition
          if (content.content.definition.isNotEmpty)
            _buildSection(
              icon: Icons.menu_book_rounded,
              title: 'Definition',
              child: _buildDefinitionCard(content.content.definition),
            ),

          // Key Points
          if (content.content.keyPoints.isNotEmpty)
            _buildSection(
              icon: Icons.star_rounded,
              title: 'Key Points',
              child: _buildKeyPoints(content.content.keyPoints),
            ),

          // Examples
          if (content.content.examples.isNotEmpty)
            _buildSection(
              icon: Icons.psychology_rounded,
              title: 'Examples',
              child: _buildExamples(content.content.examples),
            ),

          // Common Mistakes
          if (content.content.commonMistakes.isNotEmpty)
            _buildSection(
              icon: Icons.warning_rounded,
              title: 'Common Mistakes',
              child: _buildCommonMistakes(content.content.commonMistakes),
            ),

          // Summary
          if (content.content.summary.isNotEmpty)
            _buildSection(
              icon: Icons.summarize_rounded,
              title: 'Summary',
              child: _buildSummaryCard(content.content.summary),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.spaceXL),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, size: 24.w, color: gradeColor),
            ),
            SizedBox(width: AppDimensions.spaceM),
            Text(title, style: AppTextStyles.h3()),
          ],
        ),
        SizedBox(height: AppDimensions.spaceL),
        child,
      ],
    );
  }

  Widget _buildTextContent(String text) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildDefinitionCard(String definition) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradeColor.withOpacity(0.1), gradeColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: gradeColor.withOpacity(0.3), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: gradeColor, size: 32.w),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              definition,
              style: AppTextStyles.bodyLarge(
                color: AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Build key points
  Widget _buildKeyPoints(List<String> keyPoints) {
    return Column(
      children: keyPoints.asMap().entries.map((entry) {
        final index = entry.key;
        final point = entry.value;

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
          child: Container(
            margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: gradeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.button(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    point,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // NEW: Build examples using ConceptExample entity
  Widget _buildExamples(List<ConceptExample> examples) {
    return Column(
      children: examples.asMap().entries.map((entry) {
        final index = entry.key;
        final example = entry.value;

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
          child: Container(
            margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Example header
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: gradeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTextStyles.button(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Text(
                        example.title,
                        style: AppTextStyles.h5(color: gradeColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spaceM),

                // Problem
                if (example.problem.isNotEmpty) ...[
                  _buildExampleField('Problem', example.problem),
                  SizedBox(height: AppDimensions.spaceM),
                ],

                // Solution
                if (example.solution.isNotEmpty) ...[
                  _buildExampleField('Solution', example.solution),
                  SizedBox(height: AppDimensions.spaceM),
                ],

                // Explanation
                if (example.explanation.isNotEmpty)
                  _buildExampleField('Explanation', example.explanation),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExampleField(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium(
            color: AppColors.textSecondary,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppDimensions.spaceS),
        Text(
          content,
          style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  // NEW: Build common mistakes using CommonMistake entity
  Widget _buildCommonMistakes(List<CommonMistake> mistakes) {
    return Column(
      children: mistakes.asMap().entries.map((entry) {
        final index = entry.key;
        final mistake = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
          padding: EdgeInsets.all(AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mistake header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: AppColors.error,
                    size: 24.w,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Text(
                      'Mistake ${index + 1}: ${mistake.mistake}',
                      style: AppTextStyles.h5(color: AppColors.error),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spaceM),

              // Why wrong
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why it\'s wrong:',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textSecondary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppDimensions.spaceS),
                    Text(
                      mistake.whyWrong,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spaceM),

              // Correct approach
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 20.w,
                    ),
                    SizedBox(width: AppDimensions.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Correct approach:',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.success,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: AppDimensions.spaceS),
                          Text(
                            mistake.correctApproach,
                            style: AppTextStyles.bodyMedium(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradeColor.withOpacity(0.1),
            gradeColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: gradeColor.withOpacity(0.3), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: gradeColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              Icons.summarize_rounded,
              color: Colors.white,
              size: 24.w,
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              summary,
              style: AppTextStyles.bodyLarge(
                color: AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptImage(String imageUrl, Color gradeColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.spaceL,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              gradeColor.withOpacity(0.2),
              gradeColor.withOpacity(0.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: gradeColor.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL - 2),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200.h,
              color: AppColors.surface,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              return Container(
                height: 200.h,
                color: AppColors.error.withOpacity(0.1),
                child: Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 60.w,
                    color: AppColors.error,
                  ),
                ),
              );
            },
            width: double.infinity,
            height: 200.h,
          ),
        ),
      ),
    );
  }
}