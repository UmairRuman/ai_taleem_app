// Path: lib/core/data/repositories/quiz_attempts_repository.dart
import 'package:taleem_ai/core/data/collections/quiz_attempts_collection.dart';
import 'package:taleem_ai/core/domain/entities/quiz_attempt.dart';

class QuizAttemptsRepository {
  final QuizAttemptsCollection _quizAttemptsCollection =
      QuizAttemptsCollection.instance;

  Future<bool> addQuizAttempt(QuizAttempt attempt) async {
    return await _quizAttemptsCollection.addQuizAttempt(attempt);
  }

  Future<bool> updateQuizAttempt(QuizAttempt attempt) async {
    return await _quizAttemptsCollection.updateQuizAttempt(attempt);
  }

  Future<bool> deleteQuizAttempt(String attemptId) async {
    return await _quizAttemptsCollection.deleteQuizAttempt(attemptId);
  }

  Future<QuizAttempt?> getQuizAttempt(String attemptId) async {
    return await _quizAttemptsCollection.getQuizAttempt(attemptId);
  }

  Future<List<QuizAttempt>> getAllQuizAttempts() async {
    return await _quizAttemptsCollection.getAllQuizAttempts();
  }

  Future<List<QuizAttempt>> getAttemptsByUser(String userId) async {
    return await _quizAttemptsCollection.getAttemptsByUser(userId);
  }

  Future<List<QuizAttempt>> getAttemptsByQuiz(String quizId) async {
    return await _quizAttemptsCollection.getAttemptsByQuiz(quizId);
  }
}
