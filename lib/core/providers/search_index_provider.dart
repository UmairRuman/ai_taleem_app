// lib/core/presentation/providers/search_index_provider.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';

import 'package:taleem_ai/core/domain/entities/search_indexes.dart';

/// Provider for search index
/// Should be loaded once at app startup and cached
final searchIndexProvider =
    NotifierProvider<SearchIndexController, SearchIndexState>(
  SearchIndexController.new,
);

class SearchIndexController extends Notifier<SearchIndexState> {
  @override
  SearchIndexState build() {
    // Auto-load search index on initialization
    loadSearchIndex();
    return SearchIndexInitialState();
  }

  /// Load the search index (should be called once at app startup)
  Future<void> loadSearchIndex() async {
    state = SearchIndexLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final searchIndex = await repo.getSearchIndex();

      if (searchIndex != null) {
        state = SearchIndexLoadedState(searchIndex: searchIndex);
      } else {
        state = SearchIndexErrorState(error: 'Search index not found');
      }
    } catch (e) {
      state = SearchIndexErrorState(error: e.toString());
      log("Error in loading search index: ${e.toString()}");
    }
  }

  /// Get concept IDs for a grade
  List<String> getConceptIdsByGrade(int grade) {
    if (state is SearchIndexLoadedState) {
      final loadedState = state as SearchIndexLoadedState;
      return loadedState.searchIndex.getConceptsByGrade(grade);
    }
    return [];
  }

  /// Get concept IDs for a topic
  List<String> getConceptIdsByTopic(String topic) {
    if (state is SearchIndexLoadedState) {
      final loadedState = state as SearchIndexLoadedState;
      return loadedState.searchIndex.getConceptsByTopic(topic);
    }
    return [];
  }

  /// Get concept IDs with Urdu
  List<String> getConceptIdsWithUrdu() {
    if (state is SearchIndexLoadedState) {
      final loadedState = state as SearchIndexLoadedState;
      return loadedState.searchIndex.getConceptsWithUrdu();
    }
    return [];
  }

  /// Get all available grades
  List<int> getAvailableGrades() {
    if (state is SearchIndexLoadedState) {
      final loadedState = state as SearchIndexLoadedState;
      return loadedState.searchIndex.byGrade.keys
          .map((key) => int.parse(key))
          .toList()
        ..sort();
    }
    return [];
  }

  /// Get all available topics
  List<String> getAvailableTopics() {
    if (state is SearchIndexLoadedState) {
      final loadedState = state as SearchIndexLoadedState;
      return loadedState.searchIndex.byTopic.keys.toList()..sort();
    }
    return [];
  }

  /// Get all available difficulties
  List<String> getAvailableDifficulties() {
    if (state is SearchIndexLoadedState) {
      final loadedState = state as SearchIndexLoadedState;
      return loadedState.searchIndex.byDifficulty.keys.toList();
    }
    return [];
  }
}

// ============================================
// STATE CLASSES
// ============================================

abstract class SearchIndexState {}

class SearchIndexInitialState extends SearchIndexState {}

class SearchIndexLoadingState extends SearchIndexState {}

class SearchIndexLoadedState extends SearchIndexState {
  final SearchIndex searchIndex;
  SearchIndexLoadedState({required this.searchIndex});

  // Helper methods for quick access
  int get totalConcepts {
    return searchIndex.byGrade.values
        .expand((list) => list)
        .toSet()
        .length;
  }

  int get conceptsWithUrdu => searchIndex.withUrdu.length;

  double get urduCoveragePercent {
    if (totalConcepts == 0) return 0.0;
    return (conceptsWithUrdu / totalConcepts) * 100;
  }

  Map<int, int> get conceptCountByGrade {
    return searchIndex.byGrade.map(
      (key, value) => MapEntry(int.parse(key), value.length),
    );
  }

  Map<String, int> get conceptCountByTopic {
    return searchIndex.byTopic.map(
      (key, value) => MapEntry(key, value.length),
    );
  }
}

class SearchIndexErrorState extends SearchIndexState {
  final String error;
  SearchIndexErrorState({required this.error});
}