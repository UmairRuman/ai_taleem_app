// lib/features/learning/presentation/widgets/content_section_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ContentSectionWidget extends StatelessWidget {
  final Concept concept;
  final Color gradeColor;

  const ContentSectionWidget({
    super.key,
    required this.concept,
    required this.gradeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          if (concept.content.introduction != null)
            _buildSection(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Introduction',
              child: _buildTextContent(concept.content.introduction!),
            ),

          // Definition
          if (concept.content.definition != null)
            _buildSection(
              icon: Icons.menu_book_rounded,
              title: 'Definition',
              child: _buildDefinitionCard(concept.content.definition!),
            ),

          // Examples
          if (concept.content.examples != null &&
              concept.content.examples!.isNotEmpty)
            _buildSection(
              icon: Icons.psychology_rounded,
              title: 'Examples',
              child: _buildExamples(concept.content.examples!),
            ),

          // Forms (for notation)
          if (concept.content.forms != null &&
              concept.content.forms!.isNotEmpty)
            _buildSection(
              icon: Icons.text_fields_rounded,
              title: 'Representation Forms',
              child: _buildForms(concept.content.forms!),
            ),

          // Operations
          if (concept.content.operations != null &&
              concept.content.operations!.isNotEmpty)
            _buildSection(
              icon: Icons.functions_rounded,
              title: 'Operations',
              child: _buildOperations(concept.content.operations!),
            ),

          // Properties
          if (concept.content.properties != null &&
              concept.content.properties!.isNotEmpty)
            _buildSection(
              icon: Icons.settings_rounded,
              title: 'Properties',
              child: _buildProperties(concept.content.properties!),
            ),

          // Laws (for De Morgan's)
          if (concept.content.laws != null && concept.content.laws!.isNotEmpty)
            _buildSection(
              icon: Icons.gavel_rounded,
              title: 'Laws',
              child: _buildLaws(concept.content.laws!),
            ),

          // Formula
          if (concept.content.formula != null)
            _buildSection(
              icon: Icons.calculate_rounded,
              title: 'Formula',
              child: _buildFormulaCard(concept.content.formula!),
            ),

          // Example with solution
          if (concept.content.example != null)
            _buildSection(
              icon: Icons.design_services_rounded,
              title: 'Worked Example',
              child: _buildWorkedExample(concept.content.example!),
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

  Widget _buildExamples(List<Map<String, dynamic>> examples) {
    return Column(
      children:
          examples.asMap().entries.map((entry) {
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
                        if (example['rule'] != null)
                          Expanded(
                            child: Text(
                              example['rule'],
                              style: AppTextStyles.h5(color: gradeColor),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spaceM),
                    ...example.entries
                        .where((e) => e.key != 'rule')
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(
                              bottom: AppDimensions.spaceS,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_formatKey(e.key)}: ',
                                    style: AppTextStyles.bodyMedium(
                                      color: AppColors.textSecondary,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: e.value.toString(),
                                    style: AppTextStyles.bodyMedium(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildForms(List<Map<String, dynamic>> forms) {
    return Column(
      children:
          forms.map((form) {
            return Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: gradeColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                    child: Text(
                      form['name'] ?? '',
                      style: AppTextStyles.label(color: gradeColor),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceM),
                  Text(
                    form['description'] ?? '',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildOperations(List<Map<String, dynamic>> operations) {
    return Column(
      children:
          operations.map((op) {
            return Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.functions_rounded,
                        color: gradeColor,
                        size: 24.w,
                      ),
                      SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Text(
                          op['name'] ?? '',
                          style: AppTextStyles.h5(color: gradeColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spaceM),
                  Text(
                    op['description'] ?? '',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (op['example'] != null) ...[
                    SizedBox(height: AppDimensions.spaceM),
                    Container(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Text(
                        op['example'],
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textPrimary,
                        ).copyWith(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildProperties(List<Map<String, dynamic>> properties) {
    return Column(
      children:
          properties.map((prop) {
            return Container(
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
                  Icon(
                    Icons.check_circle_rounded,
                    color: gradeColor,
                    size: 24.w,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prop['name'] ?? '', style: AppTextStyles.h5()),
                        SizedBox(height: AppDimensions.spaceS),
                        Text(
                          prop['description'] ?? '',
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.textSecondary,
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

  Widget _buildLaws(List<Map<String, dynamic>> laws) {
    return Column(
      children:
          laws.map((law) {
            return Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradeColor.withOpacity(0.1),
                    gradeColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(
                  color: gradeColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    law['name'] ?? '',
                    style: AppTextStyles.h5(color: gradeColor),
                  ),
                  if (law['formula'] != null) ...[
                    SizedBox(height: AppDimensions.spaceM),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Text(
                        law['formula'],
                        style: AppTextStyles.h4(
                          color: gradeColor,
                        ).copyWith(fontFamily: 'monospace'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (law['in_words'] != null) ...[
                    SizedBox(height: AppDimensions.spaceM),
                    Text(
                      law['in_words'],
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildFormulaCard(String formula) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradeColor.withOpacity(0.15), gradeColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(color: gradeColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: gradeColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.functions_rounded, size: 40.w, color: gradeColor),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            formula,
            style: AppTextStyles.h3(
              color: gradeColor,
            ).copyWith(fontFamily: 'monospace'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkedExample(String example) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              SizedBox(width: AppDimensions.spaceM),
              Text(
                'Let\'s see how it works',
                style: AppTextStyles.label(color: AppColors.info),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            example,
            style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }
}
