// Path: lib/core/presentation/providers/concepts_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept2.dart';

final conceptsProvider =
    NotifierProvider<ConceptsStateController, ConceptsStates>(
      ConceptsStateController.new,
    );

class ConceptsStateController extends Notifier<ConceptsStates> {
  @override
  ConceptsStates build() {
    return ConceptsInitialState();
  }

  Future<void> getAllConcepts() async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concepts = await repo.getAllConcepts();
      state = ConceptsLoadedState(concepts: concepts);
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting concepts: ${e.toString()}");
    }
  }

  Future<void> getConcept(String conceptId) async {
    state = ConceptsLoadingState();
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final concept = await repo.getConcept(conceptId);
      state =
          concept != null
              ? ConceptsSingleLoadedState(concept: concept)
              : ConceptsErrorState(error: 'Concept not found');
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in getting concept: ${e.toString()}");
    }
  }

  Future<void> addConcept(Concept2 concept) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      await repo.addConcept(concept);
      await getAllConcepts(); // Refresh list
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in adding concept: ${e.toString()}");
    }
  }

  Future<void> updateConcept(Concept2 concept) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      await repo.updateConcept(concept);
      await getAllConcepts(); // Refresh list
    } catch (e) {
      state = ConceptsErrorState(error: e.toString());
      log("Error in updating concept: ${e.toString()}");
    }
  }

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
}

abstract class ConceptsStates {}

class ConceptsInitialState extends ConceptsStates {}

class ConceptsLoadingState extends ConceptsStates {}

class ConceptsLoadedState extends ConceptsStates {
  final List<Concept2> concepts;
  ConceptsLoadedState({required this.concepts});
}

class ConceptsSingleLoadedState extends ConceptsStates {
  final Concept2 concept;
  ConceptsSingleLoadedState({required this.concept});
}

class ConceptsErrorState extends ConceptsStates {
  final String error;
  ConceptsErrorState({required this.error});
}
