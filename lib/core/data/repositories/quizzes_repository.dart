// Path: lib/core/data/repositories/quizzes_repository.dart
import 'package:taleem_ai/core/data/collections/quizzes_collection.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart';

class QuizzesRepository {
  final QuizzesCollection _quizzesCollection = QuizzesCollection.instance;

  Future<bool> addQuiz(Question quiz) async {
    return await _quizzesCollection.addQuiz(quiz);
  }

  Future<bool> updateQuiz(Question quiz) async {
    return await _quizzesCollection.updateQuiz(quiz);
  }

  Future<bool> deleteQuiz(String quizId) async {
    return await _quizzesCollection.deleteQuiz(quizId);
  }

  Future<Question?> getQuiz(String quizId) async {
    return await _quizzesCollection.getQuiz(quizId);
  }

  Future<List<Question>> getAllQuizzes() async {
    return await _quizzesCollection.getAllQuizzes();
  }

  Future<List<Question>> getQuizzesByConcept(String conceptId) async {
    return await _quizzesCollection.getQuizzesByConcept(conceptId);
  }

  Future<List<Question>> getQuizzesByLesson(String lessonId) async {
    return await _quizzesCollection.getQuizzesByLesson(lessonId);
  }
}
