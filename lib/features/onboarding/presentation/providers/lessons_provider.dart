// Path: lib/core/presentation/providers/lessons_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/lesson.dart';

final lessonsProvider = NotifierProvider<LessonsStateController, LessonsStates>(
  LessonsStateController.new,
);

class LessonsStateController extends Notifier<LessonsStates> {
  @override
  LessonsStates build() {
    return LessonsInitialState();
  }

  Future<void> getAllLessons() async {
    state = LessonsLoadingState();
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      final lessons = await repo.getAllLessons();
      state = LessonsLoadedState(lessons: lessons);
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in getting lessons: ${e.toString()}");
    }
  }

  Future<void> getLesson(String lessonId) async {
    state = LessonsLoadingState();
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      final lesson = await repo.getLesson(lessonId);
      state =
          lesson != null
              ? LessonsSingleLoadedState(lesson: lesson)
              : LessonsErrorState(error: 'Lesson not found');
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in getting lesson: ${e.toString()}");
    }
  }

  Future<void> addLesson(Lesson lesson) async {
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      await repo.addLesson(lesson);
      await getAllLessons(); // Refresh list
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in adding lesson: ${e.toString()}");
    }
  }

  Future<void> updateLesson(Lesson lesson) async {
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      await repo.updateLesson(lesson);
      await getAllLessons(); // Refresh list
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in updating lesson: ${e.toString()}");
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      await repo.deleteLesson(lessonId);
      await getAllLessons(); // Refresh list
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in deleting lesson: ${e.toString()}");
    }
  }

  Future<void> getLessonsByConcept(String conceptId) async {
    state = LessonsLoadingState();
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      final lessons = await repo.getLessonsByConcept(conceptId);
      state = LessonsLoadedState(lessons: lessons);
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in getting lessons by concept: ${e.toString()}");
    }
  }

  Future<void> getLessonsByGrade(int grade) async {
    state = LessonsLoadingState();
    try {
      final repo = ref.read(lessonsRepositoryProvider);
      final lessons = await repo.getLessonsByGrade(grade);
      state = LessonsLoadedState(lessons: lessons);
    } catch (e) {
      state = LessonsErrorState(error: e.toString());
      log("Error in getting lessons by grade: ${e.toString()}");
    }
  }
}

abstract class LessonsStates {}

class LessonsInitialState extends LessonsStates {}

class LessonsLoadingState extends LessonsStates {}

class LessonsLoadedState extends LessonsStates {
  final List<Lesson> lessons;
  LessonsLoadedState({required this.lessons});
}

class LessonsSingleLoadedState extends LessonsStates {
  final Lesson lesson;
  LessonsSingleLoadedState({required this.lesson});
}

class LessonsErrorState extends LessonsStates {
  final String error;
  LessonsErrorState({required this.error});
}
