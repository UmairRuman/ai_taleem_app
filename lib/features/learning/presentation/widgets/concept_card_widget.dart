// lib/features/learning/presentation/widgets/concept_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';

// NEW: Import ConceptMetadata instead of Concept2

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConceptCardWidget extends StatefulWidget {
  // NEW: Use ConceptMetadata instead of Concept2
  final ConceptMetadata metadata;
  final Color gradeColor;
  final int index;
  final VoidCallback onTap;

  const ConceptCardWidget({
    super.key,
    required this.metadata,
    required this.gradeColor,
    required this.index,
    required this.onTap,
  });

  @override
  State<ConceptCardWidget> createState() => _ConceptCardWidgetState();
}

class _ConceptCardWidgetState extends State<ConceptCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // NEW: Updated to use metadata.difficultyLevel
  Color _getDifficultyColor() {
    switch (widget.metadata.difficultyLevel.toLowerCase()) {
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

  // NEW: Updated to use metadata.difficultyLevel
  IconData _getDifficultyIcon() {
    switch (widget.metadata.difficultyLevel.toLowerCase()) {
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

  // NEW: Display difficulty in user-friendly format
  String _getDifficultyLabel() {
    switch (widget.metadata.difficultyLevel.toLowerCase()) {
      case 'basic':
        return 'Easy';
      case 'intermediate':
        return 'Medium';
      case 'advanced':
        return 'Hard';
      default:
        return widget.metadata.difficultyLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        onTapCancel: () {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: AppDimensions.spaceL),
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(
                color:
                    _isHovered
                        ? widget.gradeColor.withOpacity(0.5)
                        : AppColors.border,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _isHovered
                          ? widget.gradeColor.withOpacity(0.15)
                          : Colors.black.withOpacity(0.05),
                  blurRadius: _isHovered ? 16 : 12,
                  offset: Offset(0, _isHovered ? 6 : 4),
                ),
                if (_isHovered)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order number badge
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.gradeColor,
                        widget.gradeColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: widget.gradeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${widget.metadata.sequenceOrder}',
                      style: AppTextStyles.h4(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(width: AppDimensions.spaceM),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NEW: Title from conceptId (formatted)
                      // The actual title will be loaded when user opens the concept
                      Text(
                        _formatConceptTitle(widget.metadata.conceptId),
                        style: AppTextStyles.h4(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: AppDimensions.spaceS),

                      // Topic badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: widget.gradeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusS,
                          ),
                        ),
                        child: Text(
                          widget.metadata.topic,
                          style: AppTextStyles.caption(
                            color: widget.gradeColor,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),

                      SizedBox(height: AppDimensions.spaceM),

                      // Stats row
                      Row(
                        children: [
                          // Difficulty
                          _buildStatItem(
                            icon: _getDifficultyIcon(),
                            label: _getDifficultyLabel(),
                            color: _getDifficultyColor(),
                          ),

                          SizedBox(width: AppDimensions.spaceL),

                          // Duration
                          _buildStatItem(
                            icon: Icons.access_time_rounded,
                            label: '${widget.metadata.estimatedTimeMinutes} min',
                            color: AppColors.textSecondary,
                          ),

                          const Spacer(),

                          // Arrow
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.w,
                            color: widget.gradeColor,
                          ),
                        ],
                      ),

                      // NEW: Additional metadata badges
                      SizedBox(height: AppDimensions.spaceM),
                      Wrap(
                        spacing: AppDimensions.spaceS,
                        runSpacing: AppDimensions.spaceS,
                        children: [
                          // Prerequisites badge
                          if (widget.metadata.hasPrerequisites)
                            _buildInfoBadge(
                              icon: Icons.link_rounded,
                              label:
                                  'Requires ${widget.metadata.prerequisites.length} prerequisite(s)',
                              color: AppColors.warning,
                              backgroundColor: AppColors.warning.withOpacity(0.1),
                            ),

                          // Quiz questions badge
                          if (widget.metadata.quizQuestionCount > 0)
                            _buildInfoBadge(
                              icon: Icons.quiz_rounded,
                              label: '${widget.metadata.quizQuestionCount} questions',
                              color: AppColors.primary,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                            ),

                          // Examples badge
                          if (widget.metadata.hasExamples)
                            _buildInfoBadge(
                              icon: Icons.lightbulb_outline_rounded,
                              label: 'Examples',
                              color: AppColors.success,
                              backgroundColor: AppColors.success.withOpacity(0.1),
                            ),

                          // Urdu available badge
                          if (widget.metadata.hasUrdu)
                            _buildInfoBadge(
                              icon: Icons.translate_rounded,
                              label: 'اردو',
                              color: widget.gradeColor,
                              backgroundColor: widget.gradeColor.withOpacity(0.1),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.w, color: color),
        SizedBox(width: AppDimensions.spaceXS),
        Text(label, style: AppTextStyles.caption(color: color)),
      ],
    );
  }

  // NEW: Info badge widget for additional metadata
  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.w, color: color),
          SizedBox(width: AppDimensions.spaceXS),
          Text(
            label,
            style: AppTextStyles.caption(color: color),
          ),
        ],
      ),
    );
  }

  // NEW: Format concept ID into readable title
  // Example: "alg_g6_L1_patterns" -> "Patterns"
  String _formatConceptTitle(String conceptId) {
    // Extract the last part after the last underscore
    final parts = conceptId.split('_');
    if (parts.isEmpty) return conceptId;

    // Get the last meaningful part
    String lastPart = parts.last;

    // Capitalize first letter and replace underscores with spaces
    return lastPart
        .split('_')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}