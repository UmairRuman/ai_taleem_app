// lib/features/learning/presentation/widgets/grade_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class GradeFilterWidget extends StatelessWidget {
  final int selectedGrade;
  final Function(int) onGradeChanged;

  const GradeFilterWidget({
    super.key,
    required this.selectedGrade,
    required this.onGradeChanged,
  });

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
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Row(
        children:
            [6, 7, 8].map((grade) {
              final isSelected = selectedGrade == grade;
              final color = _getGradeColor(grade);

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceXS,
                  ),
                  child: GestureDetector(
                    onTap: () => onGradeChanged(grade),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [color, color.withOpacity(0.7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color: isSelected ? null : AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXL,
                        ),
                        border: Border.all(
                          color: isSelected ? color : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Grade',
                            style: AppTextStyles.caption(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppDimensions.spaceXS),
                          Text(
                            '$grade',
                            style: AppTextStyles.h2(
                              color: isSelected ? Colors.white : color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// lib/features/learning/presentation/widgets/shimmer_loading_widget.dart
class ShimmerLoadingWidget extends StatefulWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  State<ShimmerLoadingWidget> createState() => _ShimmerLoadingWidgetState();
}

class _ShimmerLoadingWidgetState extends State<ShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.spaceL),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  gradient: LinearGradient(
                    begin: Alignment(_animation.value, 0),
                    end: const Alignment(1, 0),
                    colors: [
                      AppColors.surfaceVariant,
                      AppColors.surface,
                      AppColors.surfaceVariant,
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
