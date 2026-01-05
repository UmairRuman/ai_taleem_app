// lib/features/learning/presentation/screens/course_content_list_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';
import 'package:taleem_ai/core/providers/concepts_metadata_provider.dart';
import 'package:taleem_ai/core/providers/language_provider.dart';
import 'package:taleem_ai/core/routes/route_names.dart';
import 'package:taleem_ai/features/admin/fake_data_entry/institution_data_entry_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/concept_card_widget.dart';
import '../widgets/grade_filter_widget.dart';

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

    // NEW: Fetch concepts metadata on init (lightweight)
    Future.microtask(() {
      ref
          .read(conceptsMetadataProvider.notifier)
          .getMetadataByGrade(_selectedGrade);
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
    // NEW: Fetch metadata by grade
    ref.read(conceptsMetadataProvider.notifier).getMetadataByGrade(grade);
    _animationController.forward();
  }

  void _onTopicChanged(String topic) {
    setState(() {
      _selectedTopic = topic;
    });

    // NEW: Fetch metadata by grade or topic
    if (topic == 'All') {
      ref.read(conceptsMetadataProvider.notifier).getMetadataByGrade(_selectedGrade);
    } else {
      ref.read(conceptsMetadataProvider.notifier).getMetadataByTopic(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    // NEW: Watch metadata provider instead
    final metadataState = ref.watch(conceptsMetadataProvider);
    final currentLanguage = ref.watch(languageProvider).languageCode;

    // Keep your fake data generation (unchanged)
    final fakeDataGenerator = FakeDataGenerator();
    final List<Institution> institutions =
        fakeDataGenerator.generateFakeInstitutions(5);
    for (var inst in institutions) {
      ref.read(institutionRepositoryProvider).addInstitution(inst);
      log("Institution name : ${inst.name}");
    }

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
                  // Custom app bar (with language toggle)
                  _buildAppBar(currentLanguage),

                  // Grade filter
                  GradeFilterWidget(
                    selectedGrade: _selectedGrade,
                    onGradeChanged: _onGradeChanged,
                  ),

                  SizedBox(height: AppDimensions.spaceM),

                  // Topic filter
                  _buildTopicFilter(metadataState),

                  SizedBox(height: AppDimensions.spaceM),

                  // Content list (metadata only)
                  Expanded(child: _buildContent(metadataState)),
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

  Widget _buildAppBar(String currentLanguage) {
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

          // NEW: Language toggle button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(languageProvider.notifier).toggleLanguage();
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
                child: Row(
                  children: [
                    Icon(
                      Icons.language_rounded,
                      color: _getGradeColor(),
                      size: 20.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      currentLanguage.toUpperCase(),
                      style: AppTextStyles.bodySmall(
                        color: _getGradeColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: AppDimensions.spaceS),

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

  Widget _buildTopicFilter(ConceptsMetadataState state) {
    // NEW: Handle metadata state types
    if (state is! ConceptsMetadataLoadedState) return const SizedBox.shrink();

    final topics = ['All', ...state.metadataList.map((m) => m.topic).toSet()];

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

  Widget _buildContent(ConceptsMetadataState state) {
    // NEW: Handle metadata state types
    if (state is ConceptsMetadataLoadingState) {
      return const ShimmerLoadingWidget();
    }

    if (state is ConceptsMetadataErrorState) {
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
                    .read(conceptsMetadataProvider.notifier)
                    .getMetadataByGrade(_selectedGrade);
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

    if (state is ConceptsMetadataLoadedState) {
      if (state.metadataList.isEmpty) {
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

      // NEW: Sort metadata by sequenceOrder
      final sortedMetadata = List<ConceptMetadata>.from(state.metadataList)
        ..sort((a, b) => a.sequenceOrder.compareTo(b.sequenceOrder));

      return FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          itemCount: sortedMetadata.length,
          itemBuilder: (context, index) {
            final metadata = sortedMetadata[index];
            return ConceptCardWidget(
              metadata: metadata, // Pass metadata instead of concept
              gradeColor: _getGradeColor(),
              index: index,
              onTap: () {
                context.push(
                  '${RouteNames.conceptDetailScreen}/${metadata.conceptId}',
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
          boxShadow: isSelected
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

// NEW: Shimmer loading widget (placeholder - adjust to your existing implementation)
class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}