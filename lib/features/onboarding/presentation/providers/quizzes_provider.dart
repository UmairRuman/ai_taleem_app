// Path: lib/core/presentation/providers/quizzes_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart';

final quizzesProvider = NotifierProvider<QuizzesStateController, QuizzesStates>(
  QuizzesStateController.new,
);

class QuizzesStateController extends Notifier<QuizzesStates> {
  @override
  QuizzesStates build() {
    return QuizzesInitialState();
  }

  Future<void> getAllQuizzes() async {
    state = QuizzesLoadingState();
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      final quizzes = await repo.getAllQuizzes();
      state = QuizzesLoadedState(quizzes: quizzes);
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in getting quizzes: ${e.toString()}");
    }
  }

  Future<void> getQuiz(String quizId) async {
    state = QuizzesLoadingState();
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      final quiz = await repo.getQuiz(quizId);
      state =
          quiz != null
              ? QuizzesSingleLoadedState(quiz: quiz)
              : QuizzesErrorState(error: 'Quiz not found');
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in getting quiz: ${e.toString()}");
    }
  }

  Future<void> addQuiz(PracticeQuiz quiz) async {
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      await repo.addQuiz(quiz);
      await getAllQuizzes(); // Refresh list
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in adding quiz: ${e.toString()}");
    }
  }

  Future<void> updateQuiz(PracticeQuiz quiz) async {
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      await repo.updateQuiz(quiz);
      await getAllQuizzes(); // Refresh list
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in updating quiz: ${e.toString()}");
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      await repo.deleteQuiz(quizId);
      await getAllQuizzes(); // Refresh list
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in deleting quiz: ${e.toString()}");
    }
  }

  Future<void> getQuizzesByConcept(String conceptId) async {
    state = QuizzesLoadingState();
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      final quizzes = await repo.getQuizzesByConcept(conceptId);
      state = QuizzesLoadedState(quizzes: quizzes);
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in getting quizzes by concept: ${e.toString()}");
    }
  }

  Future<void> getQuizzesByLesson(String lessonId) async {
    state = QuizzesLoadingState();
    try {
      final repo = ref.read(quizzesRepositoryProvider);
      final quizzes = await repo.getQuizzesByLesson(lessonId);
      state = QuizzesLoadedState(quizzes: quizzes);
    } catch (e) {
      state = QuizzesErrorState(error: e.toString());
      log("Error in getting quizzes by lesson: ${e.toString()}");
    }
  }
}

abstract class QuizzesStates {}

class QuizzesInitialState extends QuizzesStates {}

class QuizzesLoadingState extends QuizzesStates {}

class QuizzesLoadedState extends QuizzesStates {
  final List<PracticeQuiz> quizzes;
  QuizzesLoadedState({required this.quizzes});
}

class QuizzesSingleLoadedState extends QuizzesStates {
  final PracticeQuiz quiz;
  QuizzesSingleLoadedState({required this.quiz});
}

class QuizzesErrorState extends QuizzesStates {
  final String error;
  QuizzesErrorState({required this.error});
}
