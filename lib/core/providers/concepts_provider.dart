// lib/core/presentation/providers/concepts_provider.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart';

/// Main provider for complete Concept objects (metadata + content)
/// Used for detail views where content needs to be displayed
final conceptsProvider = NotifierProvider<ConceptsController, ConceptsState>(
  ConceptsController.new,
);

class ConceptsController extends Notifier<ConceptsState> {
  @override
  ConceptsState build() {
    return ConceptsInitialState();
  }

  /// Get all concepts (metadata only for list view)
  Future<void> getAllConcepts() async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concepts = await repo.getAllConcepts();
      state = ConceptsLoadedState(concepts: concepts);
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting all concepts: ${e.toString()}");
    }
  }

  /// Get single concept with content in specified language
  Future<void> getConcept(String conceptId, String languageCode) async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concept = await repo.getConcept(conceptId, languageCode);
      state = concept != null
          ? ConceptsSingleLoadedState(concept: concept)
          : ConceptsErrorState(error: 'Concept not found');
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting concept: ${e.toString()}");
    }
  }

  /// Get concept with both languages loaded (EN + UR)
  Future<void> getConceptBothLanguages(String conceptId) async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concept = await repo.getConceptBothLanguages(conceptId);
      state = concept != null
          ? ConceptsSingleLoadedState(concept: concept)
          : ConceptsErrorState(error: 'Concept not found');
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting concept with both languages: ${e.toString()}");
    }
  }

  /// Load content into an existing concept (lazy loading)
  /// Useful when switching language on detail screen
  Future<void> loadConceptContent(Concept concept, String languageCode) async {
    // Don't show loading if content already exists
    if (concept.hasContentLoaded(languageCode)) {
      return;
    }

    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final updatedConcept = await repo.loadConceptContent(concept, languageCode);
      state = ConceptsSingleLoadedState(concept: updatedConcept);
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in loading concept content: ${e.toString()}");
    }
  }

  /// Get concepts by grade (metadata only)
  Future<void> getConceptsByGrade(int grade) async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concepts = await repo.getConceptsByGrade(grade);
      state = ConceptsLoadedState(concepts: concepts);
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting concepts by grade: ${e.toString()}");
    }
  }

  /// Get concepts by topic (metadata only)
  Future<void> getConceptsByTopic(String topic) async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concepts = await repo.getConceptsByTopic(topic);
      state = ConceptsLoadedState(concepts: concepts);
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting concepts by topic: ${e.toString()}");
    }
  }

  /// Preload content for multiple concepts (optimization)
  Future<void> preloadConceptsContent(
    List<Concept> concepts,
    String languageCode,
  ) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final conceptsMap = await repo.preloadConceptsContent(concepts, languageCode);
      
      // Update state with preloaded concepts
      final conceptsList = conceptsMap.values.toList();
      state = ConceptsLoadedState(concepts: conceptsList);
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in preloading content: ${e.toString()}");
    }
  }

  // ============================================
  // ADMIN OPERATIONS
  // ============================================

  /// Add new concept (metadata only)
  Future<void> addConceptMetadata(Concept concept) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      await repo.addConceptMetadata(concept.metadata);
      await getAllConcepts(); // Refresh list
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in adding concept metadata: ${e.toString()}");
    }
  }

  /// Update concept metadata
  Future<void> updateConceptMetadata(Concept concept) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      await repo.updateConceptMetadata(concept.metadata);
      await getAllConcepts(); // Refresh list
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in updating concept metadata: ${e.toString()}");
    }
  }

  /// Delete concept (removes metadata + all content)
  Future<void> deleteConcept(String conceptId) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      await repo.deleteConcept(conceptId);
      await getAllConcepts(); // Refresh list
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in deleting concept: ${e.toString()}");
    }
  }
}

// ============================================
// STATE CLASSES
// ============================================

abstract class ConceptsState {}

class ConceptsInitialState extends ConceptsState {}

class ConceptsLoadingState extends ConceptsState {}

class ConceptsLoadedState extends ConceptsState {
  final List<Concept> concepts;
  ConceptsLoadedState({required this.concepts});
}

class ConceptsSingleLoadedState extends ConceptsState {
  final Concept concept;
  ConceptsSingleLoadedState({required this.concept});
}

class ConceptsErrorState extends ConceptsState {
  final String error;
  ConceptsErrorState({required this.error});
}