// Path: lib/core/data/collections/quizzes_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart'; // Assuming entity path

class QuizzesCollection {
  static final QuizzesCollection instance = QuizzesCollection._internal();
  QuizzesCollection._internal();
  static var quizzesCollection = FirebaseFirestore.instance.collection(
    'quizzes',
  );
  factory QuizzesCollection() {
    return instance;
  }

  Future<bool> addQuiz(PracticeQuiz quiz) async {
    try {
      await quizzesCollection.doc(quiz.questionId).set(quiz.toMap());
      log('Quiz added successfully: ${quiz.questionId}');
      return true;
    } catch (e) {
      log("Error adding quiz: $e");
      return false;
    }
  }

  Future<bool> updateQuiz(PracticeQuiz quiz) async {
    try {
      await quizzesCollection.doc(quiz.questionId).update(quiz.toMap());
      log('Quiz updated successfully: ${quiz.questionId}');
      return true;
    } catch (e) {
      log("Error updating quiz: $e");
      return false;
    }
  }

  Future<bool> deleteQuiz(String quizId) async {
    try {
      await quizzesCollection.doc(quizId).delete();
      log('Quiz deleted successfully: $quizId');
      return true;
    } catch (e) {
      log("Error deleting quiz: $e");
      return false;
    }
  }

  Future<PracticeQuiz?> getQuiz(String quizId) async {
    try {
      DocumentSnapshot snapshot = await quizzesCollection.doc(quizId).get();
      if (snapshot.exists) {
        return PracticeQuiz.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Quiz not found: $quizId');
      return null;
    } catch (e) {
      log("Error getting quiz: $e");
      return null;
    }
  }

  Future<List<PracticeQuiz>> getAllQuizzes() async {
    List<PracticeQuiz> quizzes = [];
    try {
      QuerySnapshot snapshot = await quizzesCollection.get();
      for (var doc in snapshot.docs) {
        quizzes.add(PracticeQuiz.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${quizzes.length} quizzes');
      return quizzes;
    } catch (e) {
      log("Error getting all quizzes: $e");
      return [];
    }
  }

  // Additional useful method: Get quizzes by conceptId
  Future<List<PracticeQuiz>> getQuizzesByConcept(String conceptId) async {
    List<PracticeQuiz> quizzes = [];
    try {
      QuerySnapshot snapshot =
          await quizzesCollection
              .where('conceptId', isEqualTo: conceptId)
              .get();
      for (var doc in snapshot.docs) {
        quizzes.add(PracticeQuiz.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${quizzes.length} quizzes for concept $conceptId');
      return quizzes;
    } catch (e) {
      log("Error getting quizzes by concept: $e");
      return [];
    }
  }

  // Additional useful method: Get quizzes by lessonId
  Future<List<PracticeQuiz>> getQuizzesByLesson(String lessonId) async {
    List<PracticeQuiz> quizzes = [];
    try {
      QuerySnapshot snapshot =
          await quizzesCollection.where('lessonId', isEqualTo: lessonId).get();
      for (var doc in snapshot.docs) {
        quizzes.add(PracticeQuiz.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${quizzes.length} quizzes for lesson $lessonId');
      return quizzes;
    } catch (e) {
      log("Error getting quizzes by lesson: $e");
      return [];
    }
  }
}
