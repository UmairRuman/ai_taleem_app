// Path: lib/core/data/collections/quiz_attempts_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/quiz_attempt.dart'; // Assuming entity path

class QuizAttemptsCollection {
  static final QuizAttemptsCollection instance =
      QuizAttemptsCollection._internal();
  QuizAttemptsCollection._internal();
  static var quizAttemptsCollection = FirebaseFirestore.instance.collection(
    'quiz_attempts',
  );
  factory QuizAttemptsCollection() {
    return instance;
  }

  Future<bool> addQuizAttempt(QuizAttempt attempt) async {
    try {
      await quizAttemptsCollection.doc(attempt.id).set(attempt.toMap());
      log('Quiz attempt added successfully: ${attempt.id}');
      return true;
    } catch (e) {
      log("Error adding quiz attempt: $e");
      return false;
    }
  }

  Future<bool> updateQuizAttempt(QuizAttempt attempt) async {
    try {
      await quizAttemptsCollection.doc(attempt.id).update(attempt.toMap());
      log('Quiz attempt updated successfully: ${attempt.id}');
      return true;
    } catch (e) {
      log("Error updating quiz attempt: $e");
      return false;
    }
  }

  Future<bool> deleteQuizAttempt(String attemptId) async {
    try {
      await quizAttemptsCollection.doc(attemptId).delete();
      log('Quiz attempt deleted successfully: $attemptId');
      return true;
    } catch (e) {
      log("Error deleting quiz attempt: $e");
      return false;
    }
  }

  Future<QuizAttempt?> getQuizAttempt(String attemptId) async {
    try {
      DocumentSnapshot snapshot =
          await quizAttemptsCollection.doc(attemptId).get();
      if (snapshot.exists) {
        return QuizAttempt.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Quiz attempt not found: $attemptId');
      return null;
    } catch (e) {
      log("Error getting quiz attempt: $e");
      return null;
    }
  }

  Future<List<QuizAttempt>> getAllQuizAttempts() async {
    List<QuizAttempt> attempts = [];
    try {
      QuerySnapshot snapshot = await quizAttemptsCollection.get();
      for (var doc in snapshot.docs) {
        attempts.add(QuizAttempt.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${attempts.length} quiz attempts');
      return attempts;
    } catch (e) {
      log("Error getting all quiz attempts: $e");
      return [];
    }
  }

  // Additional useful method: Get attempts by userId
  Future<List<QuizAttempt>> getAttemptsByUser(String userId) async {
    List<QuizAttempt> attempts = [];
    try {
      QuerySnapshot snapshot =
          await quizAttemptsCollection.where('userId', isEqualTo: userId).get();
      for (var doc in snapshot.docs) {
        attempts.add(QuizAttempt.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${attempts.length} attempts for user $userId');
      return attempts;
    } catch (e) {
      log("Error getting attempts by user: $e");
      return [];
    }
  }

  // Additional useful method: Get attempts by quizId
  Future<List<QuizAttempt>> getAttemptsByQuiz(String quizId) async {
    List<QuizAttempt> attempts = [];
    try {
      QuerySnapshot snapshot =
          await quizAttemptsCollection.where('quizId', isEqualTo: quizId).get();
      for (var doc in snapshot.docs) {
        attempts.add(QuizAttempt.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${attempts.length} attempts for quiz $quizId');
      return attempts;
    } catch (e) {
      log("Error getting attempts by quiz: $e");
      return [];
    }
  }
}
