// lib/features/learning/presentation/widgets/concept_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConceptCardWidget extends StatefulWidget {
  final Concept concept;
  final Color gradeColor;
  final int index;
  final VoidCallback onTap;

  const ConceptCardWidget({
    super.key,
    required this.concept,
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

  Color _getDifficultyColor() {
    switch (widget.concept.difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.easy;
      case 'medium':
        return AppColors.medium;
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getDifficultyIcon() {
    switch (widget.concept.difficulty.toLowerCase()) {
      case 'easy':
        return Icons.sentiment_satisfied_rounded;
      case 'medium':
        return Icons.sentiment_neutral_rounded;
      case 'hard':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.help_outline_rounded;
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
                      '${widget.concept.sequenceOrder}',
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
                      // Title
                      Text(
                        widget.concept.title,
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
                          widget.concept.topic,
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
                            label: widget.concept.difficulty,
                            color: _getDifficultyColor(),
                          ),

                          SizedBox(width: AppDimensions.spaceL),

                          // Duration
                          _buildStatItem(
                            icon: Icons.access_time_rounded,
                            label: '${widget.concept.estimatedTimeMinutes} min',
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

                      // Prerequisites badge
                      if (widget.concept.prerequisites.isNotEmpty) ...[
                        SizedBox(height: AppDimensions.spaceM),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS,
                            ),
                            border: Border.all(
                              color: AppColors.warning.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.link_rounded,
                                size: 14.w,
                                color: AppColors.warning,
                              ),
                              SizedBox(width: AppDimensions.spaceXS),
                              Text(
                                'Requires ${widget.concept.prerequisites.length} prerequisite(s)',
                                style: AppTextStyles.caption(
                                  color: AppColors.warning,
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
}
