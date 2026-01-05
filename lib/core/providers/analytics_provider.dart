// lib/core/presentation/providers/analytics_provider.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';

/// Provider for curriculum analytics and statistics
/// Used for dashboard views and reporting
final analyticsProvider =
    NotifierProvider<AnalyticsController, AnalyticsState>(
  AnalyticsController.new,
);

class AnalyticsController extends Notifier<AnalyticsState> {
  @override
  AnalyticsState build() {
    return AnalyticsInitialState();
  }

  /// Load all analytics data
  Future<void> loadAnalytics() async {
    state = AnalyticsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);

      // Fetch all analytics in parallel
      final results = await Future.wait([
        repo.getTotalConceptCount(),
        repo.getConceptCountByGrade(),
        repo.getConceptCountByTopic(),
        repo.getTranslationProgress(),
        repo.getUrduCoverage(),
        repo.getMissingTranslations(),
        repo.getAvailableGrades(),
        repo.getAvailableTopics(),
        repo.getAvailableDifficulties(),
      ]);

      state = AnalyticsLoadedState(
        totalConcepts: results[0] as int,
        conceptsByGrade: results[1] as Map<int, int>,
        conceptsByTopic: results[2] as Map<String, int>,
        translationProgress: results[3] as double,
        urduCoverage: results[4] as double,
        missingTranslations: results[5] as List<String>,
        availableGrades: results[6] as List<int>,
        availableTopics: results[7] as List<String>,
        availableDifficulties: results[8] as List<String>,
      );
    } catch (e) {
      state = AnalyticsErrorState(error: e.toString());
      log("Error in loading analytics: ${e.toString()}");
    }
  }

  /// Refresh analytics data
  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }
}

// ============================================
// STATE CLASSES
// ============================================

abstract class AnalyticsState {}

class AnalyticsInitialState extends AnalyticsState {}

class AnalyticsLoadingState extends AnalyticsState {}

class AnalyticsLoadedState extends AnalyticsState {
  final int totalConcepts;
  final Map<int, int> conceptsByGrade;
  final Map<String, int> conceptsByTopic;
  final double translationProgress;
  final double urduCoverage;
  final List<String> missingTranslations;
  final List<int> availableGrades;
  final List<String> availableTopics;
  final List<String> availableDifficulties;

  AnalyticsLoadedState({
    required this.totalConcepts,
    required this.conceptsByGrade,
    required this.conceptsByTopic,
    required this.translationProgress,
    required this.urduCoverage,
    required this.missingTranslations,
    required this.availableGrades,
    required this.availableTopics,
    required this.availableDifficulties,
  });

  // Helper getters
  int get totalConceptsWithUrdu =>
      (totalConcepts * urduCoverage / 100).round();

  int get totalMissingTranslations => missingTranslations.length;

  bool get isFullyTranslated => urduCoverage >= 100.0;

  String get translationStatusMessage {
    if (isFullyTranslated) {
      return 'All concepts have Urdu translations';
    }
    return '$totalMissingTranslations concepts need Urdu translation';
  }

  // Grade with most concepts
  int? get mostPopulatedGrade {
    if (conceptsByGrade.isEmpty) return null;
    return conceptsByGrade.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // Topic with most concepts
  String? get mostPopulatedTopic {
    if (conceptsByTopic.isEmpty) return null;
    return conceptsByTopic.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

class AnalyticsErrorState extends AnalyticsState {
  final String error;
  AnalyticsErrorState({required this.error});
}