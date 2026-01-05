// lib/features/learning/presentation/screens/course_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';
import 'package:taleem_ai/core/providers/concepts_metadata_provider.dart';
import 'package:taleem_ai/core/providers/language_provider.dart';


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

  // NEW: Use ConceptMetadata instead of Concept2
  List<ConceptMetadata> _filteredMetadata = [];
  List<ConceptMetadata> _allMetadata = [];
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

    // NEW: Load all metadata (lightweight)
    Future.microtask(() {
      ref.read(conceptsMetadataProvider.notifier).getAllMetadata();
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

  // NEW: Simplified search - searches through metadata only
  void _performSearch(String query, List<ConceptMetadata> metadataList) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _filteredMetadata = [];
        return;
      }

      final lowercaseQuery = query.toLowerCase();

      _filteredMetadata = metadataList.where((metadata) {
        // Search in concept ID (contains topic/grade info)
        final idMatch = metadata.conceptId.toLowerCase().contains(lowercaseQuery);

        // Search in topic
        final topicMatch = metadata.topic.toLowerCase().contains(lowercaseQuery);

        // Search in grade
        final gradeMatch = 'grade ${metadata.gradeLevel}'.contains(lowercaseQuery);

        // Search in difficulty
        final difficultyMatch =
            metadata.difficultyLevel.toLowerCase().contains(lowercaseQuery);

        // Search in glossary terms (if concept defines any)
        final glossaryMatch = metadata.definesGlossaryTerms.any(
          (term) => term.toLowerCase().contains(lowercaseQuery),
        );

        return idMatch || topicMatch || gradeMatch || difficultyMatch || glossaryMatch;
      }).toList();

      // Sort by relevance
      _filteredMetadata.sort((a, b) {
        // Topic matches first
        final aTopicMatch = a.topic.toLowerCase().contains(lowercaseQuery);
        final bTopicMatch = b.topic.toLowerCase().contains(lowercaseQuery);

        if (aTopicMatch && !bTopicMatch) return -1;
        if (!aTopicMatch && bTopicMatch) return 1;

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
    // NEW: Watch metadata provider
    final metadataState = ref.watch(conceptsMetadataProvider);
    final currentLanguage = ref.watch(languageProvider).languageCode;

    // Update all metadata when loaded
    if (metadataState is ConceptsMetadataLoadedState) {
      _allMetadata = metadataState.metadataList;
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
              // Search header (with language toggle)
              _buildSearchHeader(currentLanguage),

              // Search results or empty state
              Expanded(child: _buildContent(metadataState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(String currentLanguage) {
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
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: AppColors.textSecondary,
                              size: 20.w,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('', _allMetadata);
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
                  onChanged: (query) => _performSearch(query, _allMetadata),
                  textInputAction: TextInputAction.search,
                ),
              ),

              // NEW: Language toggle button
              SizedBox(width: AppDimensions.spaceS),
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
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.language_rounded,
                          color: AppColors.primary,
                          size: 20.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          currentLanguage.toUpperCase(),
                          style: AppTextStyles.bodySmall(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Search stats
          if (_searchQuery.isNotEmpty) ...[
            SizedBox(height: AppDimensions.spaceM),
            Row(
              children: [
                // Results count
                Expanded(
                  child: Text(
                    'Found ${_filteredMetadata.length} result${_filteredMetadata.length != 1 ? 's' : ''}',
                    style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
                  ),
                ),

                // Filter chips (if needed)
                if (_filteredMetadata.isNotEmpty) ...[
                  _buildFilterChip(
                    'By Grade',
                    Icons.school_rounded,
                  ),
                  SizedBox(width: AppDimensions.spaceS),
                  _buildFilterChip(
                    'By Topic',
                    Icons.category_rounded,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // Show filter bottom sheet
        _showFilterBottomSheet();
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingXS,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: AppColors.primary),
            SizedBox(width: AppDimensions.spaceXS),
            Text(
              label,
              style: AppTextStyles.caption(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    
    // Can use conceptsFilterProvider here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter feature coming soon')),
    );
  }

  // NEW: Updated to handle metadata states
  Widget _buildContent(ConceptsMetadataState state) {
    if (state is ConceptsMetadataLoadingState) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is ConceptsMetadataErrorState) {
      return _buildError(state.error);
    }

    if (_searchQuery.isEmpty) {
      return _buildEmptySearch();
    }

    if (_filteredMetadata.isEmpty) {
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
              'Try searching by:\n• Topic (e.g., "Algebra", "Sets")\n• Grade level (e.g., "Grade 6")\n• Difficulty (e.g., "Basic", "Advanced")\n• Keywords from concepts',
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
          SizedBox(height: AppDimensions.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _performSearch('', _allMetadata);
            },
            icon: const Icon(Icons.clear_all_rounded),
            label: const Text('Clear Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
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
        itemCount: _filteredMetadata.length,
        itemBuilder: (context, index) {
          final metadata = _filteredMetadata[index];
          final gradeColor = _getGradeColor(metadata.gradeLevel);

          return ConceptCardWidget(
            metadata: metadata, // Pass metadata
            gradeColor: gradeColor,
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

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64.w, color: AppColors.error),
          SizedBox(height: AppDimensions.spaceL),
          Text('Failed to load concepts', style: AppTextStyles.h4()),
          SizedBox(height: AppDimensions.spaceS),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
            child: Text(
              error,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppDimensions.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(conceptsMetadataProvider.notifier).getAllMetadata();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}