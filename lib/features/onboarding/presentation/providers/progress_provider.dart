// Path: lib/core/presentation/providers/progress_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept_progress.dart';
import 'package:taleem_ai/core/domain/entities/lesson_progress.dart';

final progressProvider =
    NotifierProvider<ProgressStateController, ProgressStates>(
      ProgressStateController.new,
    );

class ProgressStateController extends Notifier<ProgressStates> {
  @override
  ProgressStates build() {
    return ProgressInitialState();
  }

  // Lesson Progress
  Future<void> getAllLessonProgress(String userId) async {
    state = ProgressLoadingState();
    try {
      final repo = ref.read(progressRepositoryProvider);
      final progresses = await repo.getAllLessonProgress(userId);
      state = ProgressLessonLoadedState(lessonProgresses: progresses);
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in getting lesson progresses: ${e.toString()}");
    }
  }

  Future<void> getLessonProgress(String userId, String lessonId) async {
    state = ProgressLoadingState();
    try {
      final repo = ref.read(progressRepositoryProvider);
      final progress = await repo.getLessonProgress(userId, lessonId);
      state =
          progress != null
              ? ProgressSingleLessonLoadedState(lessonProgress: progress)
              : ProgressErrorState(error: 'Lesson progress not found');
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in getting lesson progress: ${e.toString()}");
    }
  }

  Future<void> addLessonProgress(String userId, LessonProgress progress) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.addLessonProgress(userId, progress);
      await getAllLessonProgress(userId); // Refresh list
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in adding lesson progress: ${e.toString()}");
    }
  }

  Future<void> updateLessonProgress(
    String userId,
    LessonProgress progress,
  ) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.updateLessonProgress(userId, progress);
      await getAllLessonProgress(userId); // Refresh list
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in updating lesson progress: ${e.toString()}");
    }
  }

  Future<void> deleteLessonProgress(String userId, String lessonId) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.deleteLessonProgress(userId, lessonId);
      await getAllLessonProgress(userId); // Refresh list
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in deleting lesson progress: ${e.toString()}");
    }
  }

  // Concept Progress
  Future<void> getAllConceptProgress(String userId) async {
    state = ProgressLoadingState();
    try {
      final repo = ref.read(progressRepositoryProvider);
      final progresses = await repo.getAllConceptProgress(userId);
      state = ProgressConceptLoadedState(conceptProgresses: progresses);
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in getting concept progresses: ${e.toString()}");
    }
  }

  Future<void> getConceptProgress(String userId, String conceptId) async {
    state = ProgressLoadingState();
    try {
      final repo = ref.read(progressRepositoryProvider);
      final progress = await repo.getConceptProgress(userId, conceptId);
      state =
          progress != null
              ? ProgressSingleConceptLoadedState(conceptProgress: progress)
              : ProgressErrorState(error: 'Concept progress not found');
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in getting concept progress: ${e.toString()}");
    }
  }

  Future<void> addConceptProgress(
    String userId,
    ConceptProgress progress,
  ) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.addConceptProgress(userId, progress);
      await getAllConceptProgress(userId); // Refresh list
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in adding concept progress: ${e.toString()}");
    }
  }

  Future<void> updateConceptProgress(
    String userId,
    ConceptProgress progress,
  ) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.updateConceptProgress(userId, progress);
      await getAllConceptProgress(userId); // Refresh list
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in updating concept progress: ${e.toString()}");
    }
  }

  Future<void> deleteConceptProgress(String userId, String conceptId) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.deleteConceptProgress(userId, conceptId);
      await getAllConceptProgress(userId); // Refresh list
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in deleting concept progress: ${e.toString()}");
    }
  }

  Future<void> updateMasteryLevel(
    String userId,
    String conceptId,
    int masteryLevel,
  ) async {
    try {
      final repo = ref.read(progressRepositoryProvider);
      await repo.updateMasteryLevel(userId, conceptId, masteryLevel);
      await getConceptProgress(userId, conceptId); // Refresh single
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in updating mastery level: ${e.toString()}");
    }
  }

  Future<void> getStrugglingConcepts(String userId) async {
    state = ProgressLoadingState();
    try {
      final repo = ref.read(progressRepositoryProvider);
      final progresses = await repo.getStrugglingConcepts(userId);
      state = ProgressConceptLoadedState(conceptProgresses: progresses);
    } catch (e) {
      state = ProgressErrorState(error: e.toString());
      log("Error in getting struggling concepts: ${e.toString()}");
    }
  }
}

abstract class ProgressStates {}

class ProgressInitialState extends ProgressStates {}

class ProgressLoadingState extends ProgressStates {}

class ProgressLessonLoadedState extends ProgressStates {
  final List<LessonProgress> lessonProgresses;
  ProgressLessonLoadedState({required this.lessonProgresses});
}

class ProgressSingleLessonLoadedState extends ProgressStates {
  final LessonProgress lessonProgress;
  ProgressSingleLessonLoadedState({required this.lessonProgress});
}

class ProgressConceptLoadedState extends ProgressStates {
  final List<ConceptProgress> conceptProgresses;
  ProgressConceptLoadedState({required this.conceptProgresses});
}

class ProgressSingleConceptLoadedState extends ProgressStates {
  final ConceptProgress conceptProgress;
  ProgressSingleConceptLoadedState({required this.conceptProgress});
}

class ProgressErrorState extends ProgressStates {
  final String error;
  ProgressErrorState({required this.error});
}
