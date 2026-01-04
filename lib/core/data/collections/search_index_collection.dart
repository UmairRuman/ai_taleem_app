// lib/core/data/collections/search_index_collection.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/search_indexes.dart';


/// Collection handler for system/search_index
/// Manages pre-built indices for quick filtering and lookups
/// This is a READ-ONLY collection for the app (written by admin tools)
class SearchIndexCollection {
  final FirebaseFirestore _firestore;
  
  static const String collectionName = 'system';
  static const String documentId = 'search_index';

  SearchIndexCollection({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to the search index document
  DocumentReference get _document =>
      _firestore.collection(collectionName).doc(documentId);

  // ============================================
  // READ OPERATIONS
  // ============================================

  /// Fetch the complete search index
  /// This should be called once during app initialization
  /// and cached in memory for fast lookups
  Future<SearchIndex?> getSearchIndex() async {
    try {
      final doc = await _document.get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return SearchIndex.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch search index: $e');
    }
  }

  /// Stream the search index for real-time updates
  /// Useful if the index is updated dynamically (e.g., when new content is added)
  Stream<SearchIndex?> watchSearchIndex() {
    return _document.snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return SearchIndex.fromFirestore(doc.data() as Map<String, dynamic>);
    });
  }

  // ============================================
  // CONVENIENCE METHODS
  // These wrap SearchIndex methods for direct querying
  // ============================================

  /// Get concept IDs for a specific grade
  Future<List<String>> getConceptIdsByGrade(int grade) async {
    final index = await getSearchIndex();
    return index?.getConceptsByGrade(grade) ?? [];
  }

  /// Get concept IDs for a specific topic
  Future<List<String>> getConceptIdsByTopic(String topic) async {
    final index = await getSearchIndex();
    return index?.getConceptsByTopic(topic) ?? [];
  }

  /// Get concept IDs by difficulty
  Future<List<String>> getConceptIdsByDifficulty(String difficulty) async {
    final index = await getSearchIndex();
    return index?.byDifficulty[difficulty] ?? [];
  }

  /// Get concept IDs that have Urdu translations
  Future<List<String>> getConceptIdsWithUrdu() async {
    final index = await getSearchIndex();
    return index?.getConceptsWithUrdu() ?? [];
  }

  /// Get filtered concept IDs based on multiple criteria
  /// Returns intersection of all filters applied
  Future<List<String>> getFilteredConceptIds({
    int? grade,
    String? topic,
    String? difficulty,
    bool? urduOnly,
  }) async {
    final index = await getSearchIndex();
    if (index == null) return [];

    // Start with all concepts from the first filter
    Set<String>? results;

    if (grade != null) {
      results = index.getConceptsByGrade(grade).toSet();
    }

    if (topic != null) {
      final topicIds = index.getConceptsByTopic(topic).toSet();
      results = results == null ? topicIds : results.intersection(topicIds);
    }

    if (difficulty != null) {
      final difficultyIds = (index.byDifficulty[difficulty] ?? []).toSet();
      results = results == null
          ? difficultyIds
          : results.intersection(difficultyIds);
    }

    if (urduOnly == true) {
      final urduIds = index.getConceptsWithUrdu().toSet();
      results = results == null ? urduIds : results.intersection(urduIds);
    }

    return results?.toList() ?? [];
  }

  /// Get all available grades
  Future<List<int>> getAvailableGrades() async {
    final index = await getSearchIndex();
    if (index == null) return [];

    return index.byGrade.keys.map((key) => int.parse(key)).toList()..sort();
  }

  /// Get all available topics
  Future<List<String>> getAvailableTopics() async {
    final index = await getSearchIndex();
    if (index == null) return [];

    return index.byTopic.keys.toList()..sort();
  }

  /// Get all available difficulty levels
  Future<List<String>> getAvailableDifficulties() async {
    final index = await getSearchIndex();
    if (index == null) return [];

    return index.byDifficulty.keys.toList();
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Get concept count by grade
  Future<Map<int, int>> getConceptCountByGrade() async {
    final index = await getSearchIndex();
    if (index == null) return {};

    return index.byGrade.map(
      (key, value) => MapEntry(int.parse(key), value.length),
    );
  }

  /// Get concept count by topic
  Future<Map<String, int>> getConceptCountByTopic() async {
    final index = await getSearchIndex();
    if (index == null) return {};

    return index.byTopic.map(
      (key, value) => MapEntry(key, value.length),
    );
  }

  /// Get total concepts with Urdu
  Future<int> getUrduConceptCount() async {
    final index = await getSearchIndex();
    return index?.withUrdu.length ?? 0;
  }

  /// Get Urdu translation coverage percentage
  Future<double> getUrduCoverage() async {
    final index = await getSearchIndex();
    if (index == null) return 0.0;

    // Calculate total unique concepts across all grades
    final allConcepts = <String>{};
    for (final concepts in index.byGrade.values) {
      allConcepts.addAll(concepts);
    }

    if (allConcepts.isEmpty) return 0.0;

    final urduCount = index.withUrdu.length;
    return (urduCount / allConcepts.length) * 100;
  }

  // ============================================
  // WRITE OPERATIONS (For admin tools only)
  // ============================================

  /// Update the entire search index
  /// This should only be called by admin/content management tools
  Future<void> updateSearchIndex(SearchIndex index) async {
    try {
      await _document.set(
        _searchIndexToFirestore(index),
        SetOptions(merge: false),
      );
    } catch (e) {
      throw Exception('Failed to update search index: $e');
    }
  }

  /// Convert SearchIndex to Firestore map
  Map<String, dynamic> _searchIndexToFirestore(SearchIndex index) {
    return {
      'byGrade': index.byGrade,
      'byTopic': index.byTopic,
      'byDifficulty': index.byDifficulty,
      'withUrdu': index.withUrdu,
    };
  }

  /// Partially update search index (merge mode)
  Future<void> updateSearchIndexPartial(Map<String, dynamic> updates) async {
    try {
      await _document.set(
        updates,
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to partially update search index: $e');
    }
  }

  /// Add a concept to the index
  /// Updates the relevant grade, topic, and difficulty lists
  Future<void> addConceptToIndex({
    required String conceptId,
    required int grade,
    required String topic,
    required String difficulty,
    required bool hasUrdu,
  }) async {
    try {
      final index = await getSearchIndex();
      if (index == null) {
        throw Exception('Search index does not exist');
      }

      // Update grade list
      final gradeKey = grade.toString();
      final gradeList = List<String>.from(index.byGrade[gradeKey] ?? []);
      if (!gradeList.contains(conceptId)) {
        gradeList.add(conceptId);
      }

      // Update topic list
      final topicList = List<String>.from(index.byTopic[topic] ?? []);
      if (!topicList.contains(conceptId)) {
        topicList.add(conceptId);
      }

      // Update difficulty list
      final difficultyList =
          List<String>.from(index.byDifficulty[difficulty] ?? []);
      if (!difficultyList.contains(conceptId)) {
        difficultyList.add(conceptId);
      }

      // Update Urdu list
      final urduList = List<String>.from(index.withUrdu);
      if (hasUrdu && !urduList.contains(conceptId)) {
        urduList.add(conceptId);
      }

      // Update document
      await _document.update({
        'byGrade.$gradeKey': gradeList,
        'byTopic.$topic': topicList,
        'byDifficulty.$difficulty': difficultyList,
        'withUrdu': urduList,
      });
    } catch (e) {
      throw Exception('Failed to add concept to index: $e');
    }
  }

  /// Remove a concept from the index
  Future<void> removeConceptFromIndex(String conceptId) async {
    try {
      final index = await getSearchIndex();
      if (index == null) return;

      // Remove from all lists
      final updates = <String, dynamic>{};

      index.byGrade.forEach((key, value) {
        final updated = value.where((id) => id != conceptId).toList();
        updates['byGrade.$key'] = updated;
      });

      index.byTopic.forEach((key, value) {
        final updated = value.where((id) => id != conceptId).toList();
        updates['byTopic.$key'] = updated;
      });

      index.byDifficulty.forEach((key, value) {
        final updated = value.where((id) => id != conceptId).toList();
        updates['byDifficulty.$key'] = updated;
      });

      updates['withUrdu'] =
          index.withUrdu.where((id) => id != conceptId).toList();

      await _document.update(updates);
    } catch (e) {
      throw Exception('Failed to remove concept from index: $e');
    }
  }

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Check if search index exists
  Future<bool> exists() async {
    try {
      final doc = await _document.get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check search index existence: $e');
    }
  }

  /// Initialize search index with empty structure
  Future<void> initializeIndex() async {
    try {
      final emptyIndex = SearchIndex(
        byGrade: {'6': [], '7': [], '8': []},
        byTopic: {'Algebra': [], 'Sets': []},
        byDifficulty: {'Basic': [], 'Intermediate': [], 'Advanced': []},
        withUrdu: [],
      );

      await _document.set(_searchIndexToFirestore(emptyIndex));
    } catch (e) {
      throw Exception('Failed to initialize search index: $e');
    }
  }
}