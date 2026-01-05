// lib/core/presentation/providers/concepts_metadata_provider.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';


/// Provider for concept metadata (lightweight, language-independent data)
/// Used for list views, filtering, and navigation
final conceptsMetadataProvider =
    NotifierProvider<ConceptsMetadataController, ConceptsMetadataState>(
  ConceptsMetadataController.new,
);

class ConceptsMetadataController extends Notifier<ConceptsMetadataState> {
  @override
  ConceptsMetadataState build() {
    return ConceptsMetadataInitialState();
  }

  /// Get all concept metadata (for browsing all concepts)
  Future<void> getAllMetadata() async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadataList = await repo.getAllMetadata();
      state = ConceptsMetadataLoadedState(metadataList: metadataList);
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting all metadata: ${e.toString()}");
    }
  }

  /// Get single concept metadata
  Future<void> getMetadata(String conceptId) async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadata = await repo.getMetadata(conceptId);
      state = metadata != null
          ? ConceptsMetadataSingleLoadedState(metadata: metadata)
          : ConceptsMetadataErrorState(error: 'Metadata not found');
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting metadata: ${e.toString()}");
    }
  }

  /// Get metadata by grade (for grade-specific browsing)
  Future<void> getMetadataByGrade(int grade) async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadataList = await repo.getMetadataByGrade(grade);
      state = ConceptsMetadataLoadedState(metadataList: metadataList);
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting metadata by grade: ${e.toString()}");
    }
  }

  /// Get metadata by topic (for topic-specific browsing)
  Future<void> getMetadataByTopic(String topic) async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadataList = await repo.getMetadataByTopic(topic);
      state = ConceptsMetadataLoadedState(metadataList: metadataList);
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting metadata by topic: ${e.toString()}");
    }
  }

  /// Get metadata by difficulty
  Future<void> getMetadataByDifficulty(String difficulty) async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadataList = await repo.getMetadataByDifficulty(difficulty);
      state = ConceptsMetadataLoadedState(metadataList: metadataList);
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting metadata by difficulty: ${e.toString()}");
    }
  }

  /// Get metadata for concepts with Urdu translations
  Future<void> getMetadataWithUrdu() async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadataList = await repo.getMetadataWithUrdu();
      state = ConceptsMetadataLoadedState(metadataList: metadataList);
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting metadata with Urdu: ${e.toString()}");
    }
  }

  /// Get metadata by multiple IDs (for prerequisite loading)
  Future<void> getMetadataByIds(List<String> conceptIds) async {
    state = ConceptsMetadataLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final metadataList = await repo.getMetadataByIds(conceptIds);
      state = ConceptsMetadataLoadedState(metadataList: metadataList);
    } catch (e) {
      state = ConceptsMetadataErrorState(error: e.toString());
      log("Error in getting metadata by IDs: ${e.toString()}");
    }
  }
}

// ============================================
// STATE CLASSES
// ============================================

abstract class ConceptsMetadataState {}

class ConceptsMetadataInitialState extends ConceptsMetadataState {}

class ConceptsMetadataLoadingState extends ConceptsMetadataState {}

class ConceptsMetadataLoadedState extends ConceptsMetadataState {
  final List<ConceptMetadata> metadataList;
  ConceptsMetadataLoadedState({required this.metadataList});
}

class ConceptsMetadataSingleLoadedState extends ConceptsMetadataState {
  final ConceptMetadata metadata;
  ConceptsMetadataSingleLoadedState({required this.metadata});
}

class ConceptsMetadataErrorState extends ConceptsMetadataState {
  final String error;
  ConceptsMetadataErrorState({required this.error});
}