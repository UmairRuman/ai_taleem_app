// Path: lib/core/presentation/providers/quiz_attempts_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/quiz_attempt.dart';

final quizAttemptsProvider =
    NotifierProvider<QuizAttemptsStateController, QuizAttemptsStates>(
      QuizAttemptsStateController.new,
    );

class QuizAttemptsStateController extends Notifier<QuizAttemptsStates> {
  @override
  QuizAttemptsStates build() {
    return QuizAttemptsInitialState();
  }

  Future<void> getAllQuizAttempts() async {
    state = QuizAttemptsLoadingState();
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      final attempts = await repo.getAllQuizAttempts();
      state = QuizAttemptsLoadedState(attempts: attempts);
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in getting quiz attempts: ${e.toString()}");
    }
  }

  Future<void> getQuizAttempt(String attemptId) async {
    state = QuizAttemptsLoadingState();
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      final attempt = await repo.getQuizAttempt(attemptId);
      state =
          attempt != null
              ? QuizAttemptsSingleLoadedState(attempt: attempt)
              : QuizAttemptsErrorState(error: 'Quiz attempt not found');
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in getting quiz attempt: ${e.toString()}");
    }
  }

  Future<void> addQuizAttempt(QuizAttempt attempt) async {
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      await repo.addQuizAttempt(attempt);
      await getAllQuizAttempts(); // Refresh list
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in adding quiz attempt: ${e.toString()}");
    }
  }

  Future<void> updateQuizAttempt(QuizAttempt attempt) async {
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      await repo.updateQuizAttempt(attempt);
      await getAllQuizAttempts(); // Refresh list
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in updating quiz attempt: ${e.toString()}");
    }
  }

  Future<void> deleteQuizAttempt(String attemptId) async {
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      await repo.deleteQuizAttempt(attemptId);
      await getAllQuizAttempts(); // Refresh list
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in deleting quiz attempt: ${e.toString()}");
    }
  }

  Future<void> getAttemptsByUser(String userId) async {
    state = QuizAttemptsLoadingState();
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      final attempts = await repo.getAttemptsByUser(userId);
      state = QuizAttemptsLoadedState(attempts: attempts);
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in getting attempts by user: ${e.toString()}");
    }
  }

  Future<void> getAttemptsByQuiz(String quizId) async {
    state = QuizAttemptsLoadingState();
    try {
      final repo = ref.read(quizAttemptsRepositoryProvider);
      final attempts = await repo.getAttemptsByQuiz(quizId);
      state = QuizAttemptsLoadedState(attempts: attempts);
    } catch (e) {
      state = QuizAttemptsErrorState(error: e.toString());
      log("Error in getting attempts by quiz: ${e.toString()}");
    }
  }
}

abstract class QuizAttemptsStates {}

class QuizAttemptsInitialState extends QuizAttemptsStates {}

class QuizAttemptsLoadingState extends QuizAttemptsStates {}

class QuizAttemptsLoadedState extends QuizAttemptsStates {
  final List<QuizAttempt> attempts;
  QuizAttemptsLoadedState({required this.attempts});
}

class QuizAttemptsSingleLoadedState extends QuizAttemptsStates {
  final QuizAttempt attempt;
  QuizAttemptsSingleLoadedState({required this.attempt});
}

class QuizAttemptsErrorState extends QuizAttemptsStates {
  final String error;
  QuizAttemptsErrorState({required this.error});
}
