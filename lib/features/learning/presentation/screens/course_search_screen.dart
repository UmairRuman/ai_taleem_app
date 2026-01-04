// lib/features/learning/presentation/screens/course_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/constants/storage_keys.dart';
import 'package:taleem_ai/features/onboarding/presentation/providers/concepts_provider.dart';

import '../../../../core/domain/entities/concept2.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/concept_card_widget.dart';

class CourseSearchScreen extends ConsumerStatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  ConsumerState<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends ConsumerState<CourseSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Concept2> _filteredConcepts = [];
  List<Concept2> _allConcepts = [];
  String _searchQuery = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    // Load all concepts
    Future.microtask(() {
      ref.read(conceptsProvider.notifier).getAllConcepts();
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query, List<Concept2> concepts) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _filteredConcepts = [];
        return;
      }

      final lowercaseQuery = query.toLowerCase();

      _filteredConcepts =
          concepts.where((concept) {
            // Get localized content safely
            final localizedContent =
                concept.localizedContent[AppConstants.english];

            // Search in title
            final titleMatch =
                localizedContent?.title.toLowerCase().contains(
                  lowercaseQuery,
                ) ??
                false;

            // Search in topic
            final topicMatch = concept.topic.toLowerCase().contains(
              lowercaseQuery,
            );

            // Search in grade
            final gradeMatch = 'grade ${concept.gradeLevel}'.contains(
              lowercaseQuery,
            );

            // Search in content introduction
            final introMatch =
                localizedContent?.content.introduction?.toLowerCase().contains(
                  lowercaseQuery,
                ) ??
                false;

            // Search in definition
            final defMatch =
                localizedContent?.content.definition?.toLowerCase().contains(
                  lowercaseQuery,
                ) ??
                false;

            return titleMatch ||
                topicMatch ||
                gradeMatch ||
                introMatch ||
                defMatch;
          }).toList();

      // Sort by relevance (title matches first)
      _filteredConcepts.sort((a, b) {
        final aLocalizedContent = a.localizedContent[AppConstants.english];
        final bLocalizedContent = b.localizedContent[AppConstants.english];

        final aTitle =
            aLocalizedContent?.title.toLowerCase().contains(lowercaseQuery) ??
            false;

        final bTitle =
            bLocalizedContent?.title.toLowerCase().contains(lowercaseQuery) ??
            false;

        if (aTitle && !bTitle) return -1;
        if (!aTitle && bTitle) return 1;

        // Then by sequence order
        return a.sequenceOrder.compareTo(b.sequenceOrder);
      });
    });
  }

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
    final conceptsState = ref.watch(conceptsProvider);

    // Update all concepts when loaded
    if (conceptsState is ConceptsLoadedState) {
      _allConcepts = conceptsState.concepts;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.primaryLight.withOpacity(0.05),
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search header
              _buildSearchHeader(),

              // Search results or empty state
              Expanded(child: _buildContent(conceptsState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
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

              // Search field
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search concepts, topics, or grades...',
                    hintStyle: AppTextStyles.bodyMedium(
                      color: AppColors.textTertiary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 24.w,
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: AppColors.textSecondary,
                                size: 20.w,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch('', _allConcepts);
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingM,
                    ),
                  ),
                  style: AppTextStyles.bodyLarge(),
                  onChanged: (query) => _performSearch(query, _allConcepts),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],
          ),

          // Search stats
          if (_searchQuery.isNotEmpty) ...[
            SizedBox(height: AppDimensions.spaceM),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Found ${_filteredConcepts.length} result${_filteredConcepts.length != 1 ? 's' : ''}',
                style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(ConceptsStates state) {
    if (state is ConceptsLoadingState) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is ConceptsErrorState) {
      return _buildError(state.error);
    }

    if (_searchQuery.isEmpty) {
      return _buildEmptySearch();
    }

    if (_filteredConcepts.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 80.w,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            'Search for Concepts',
            style: AppTextStyles.h3(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
            child: Text(
              'Try searching by:\n• Concept title\n• Topic (e.g., "Sets")\n• Grade level\n• Keywords from content',
              style: AppTextStyles.bodyMedium(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80.w,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            'No Results Found',
            style: AppTextStyles.h3(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
            child: Text(
              'Try different keywords or check your spelling',
              style: AppTextStyles.bodyMedium(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        itemCount: _filteredConcepts.length,
        itemBuilder: (context, index) {
          final concept = _filteredConcepts[index];
          final gradeColor = _getGradeColor(concept.gradeLevel);

          return ConceptCardWidget(
            concept: concept,
            gradeColor: gradeColor,
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

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64.w, color: AppColors.error),
          SizedBox(height: AppDimensions.spaceL),
          Text('Failed to load concepts', style: AppTextStyles.h4()),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            error,
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
