// lib/features/learning/presentation/screens/course_content_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/routes/route_names.dart';
import 'package:taleem_ai/features/onboarding/presentation/providers/concepts_provider.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/concept_card_widget.dart';
import '../widgets/grade_filter_widget.dart';
// import '../widgets/shimmer_loading_widget.dart';

class CourseContentListScreen extends ConsumerStatefulWidget {
  final int? initialGrade;

  const CourseContentListScreen({super.key, this.initialGrade});

  @override
  ConsumerState<CourseContentListScreen> createState() =>
      _CourseContentListScreenState();
}

class _CourseContentListScreenState
    extends ConsumerState<CourseContentListScreen>
    with SingleTickerProviderStateMixin {
  int _selectedGrade = 6;
  String _selectedTopic = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedGrade = widget.initialGrade ?? 6;
    _initializeAnimations();

    // Fetch concepts on init
    Future.microtask(() {
      ref.read(conceptsProvider.notifier).getConceptsByGrade(_selectedGrade);
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onGradeChanged(int grade) {
    setState(() {
      _selectedGrade = grade;
      _selectedTopic = 'All';
    });

    _animationController.reset();
    ref.read(conceptsProvider.notifier).getConceptsByGrade(grade);
    _animationController.forward();
  }

  void _onTopicChanged(String topic) {
    setState(() {
      _selectedTopic = topic;
    });

    if (topic == 'All') {
      ref.read(conceptsProvider.notifier).getConceptsByGrade(_selectedGrade);
    } else {
      ref.read(conceptsProvider.notifier).getConceptsByTopic(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final conceptsState = ref.watch(conceptsProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              _getGradeColor().withOpacity(0.05),
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorations
            _buildBackgroundDecorations(),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  _buildAppBar(),

                  // Grade filter
                  GradeFilterWidget(
                    selectedGrade: _selectedGrade,
                    onGradeChanged: _onGradeChanged,
                  ),

                  SizedBox(height: AppDimensions.spaceM),

                  // Topic filter
                  _buildTopicFilter(conceptsState),

                  SizedBox(height: AppDimensions.spaceM),

                  // Content list
                  Expanded(child: _buildContent(conceptsState)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getGradeColor().withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -40,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getGradeColor().withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pop(),
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
                  Icons.arrow_back_rounded,
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
                Text('Course Content', style: AppTextStyles.h3()),
                Text(
                  'Grade $_selectedGrade Mathematics',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Search icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push(RouteNames.courseSearchScreen);
              },
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
                  Icons.search_rounded,
                  color: _getGradeColor(),
                  size: 24.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicFilter(ConceptsStates state) {
    if (state is! ConceptsLoadedState) return const SizedBox.shrink();

    final topics = ['All', ...state.concepts.map((c) => c.topic).toSet()];

    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final isSelected = _selectedTopic == topic;

          return Padding(
            padding: EdgeInsets.only(right: AppDimensions.spaceM),
            child: _TopicChip(
              topic: topic,
              isSelected: isSelected,
              color: _getGradeColor(),
              onTap: () => _onTopicChanged(topic),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ConceptsStates state) {
    if (state is ConceptsLoadingState) {
      return const ShimmerLoadingWidget();
    }

    if (state is ConceptsErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: AppDimensions.spaceL),
            Text('Error loading concepts', style: AppTextStyles.h4()),
            SizedBox(height: AppDimensions.spaceS),
            Text(
              state.error,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceL),
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(conceptsProvider.notifier)
                    .getConceptsByGrade(_selectedGrade);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getGradeColor(),
              ),
            ),
          ],
        ),
      );
    }

    if (state is ConceptsLoadedState) {
      if (state.concepts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 64.w,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: AppDimensions.spaceL),
              Text(
                'No concepts found',
                style: AppTextStyles.h4(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      // Sort concepts by order
      final sortedConcepts = List<Concept>.from(state.concepts)
        ..sort((a, b) => a.order.compareTo(b.order));

      return FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          itemCount: sortedConcepts.length,
          itemBuilder: (context, index) {
            final concept = sortedConcepts[index];
            return ConceptCardWidget(
              concept: concept,
              gradeColor: _getGradeColor(),
              index: index,
              onTap: () {
                context.push(
                  '${RouteNames.conceptDetailScreen}/${concept.conceptId}',
                );
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Color _getGradeColor() {
    switch (_selectedGrade) {
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
}

class _TopicChip extends StatelessWidget {
  final String topic;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TopicChip({
    required this.topic,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          topic,
          style: AppTextStyles.button(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
