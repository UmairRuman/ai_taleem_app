// Path: lib/core/domain/entities/quiz_attempt.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttempt {
  final String id;
  final String userId;
  final String quizId;
  final String conceptId;
  final Map<String, String> answers;
  final int score;
  final int percentage;
  final bool passed;
  final int timeSpentSeconds;
  final DateTime startedAt;
  final DateTime completedAt;

  QuizAttempt({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.conceptId,
    required this.answers,
    required this.score,
    required this.percentage,
    required this.passed,
    required this.timeSpentSeconds,
    required this.startedAt,
    required this.completedAt,
  });

  factory QuizAttempt.fromMap(Map<String, dynamic> map) {
    return QuizAttempt(
      id: map['id'] as String,
      userId: map['userId'] as String,
      quizId: map['quizId'] as String,
      conceptId: map['conceptId'] as String,
      answers: Map<String, String>.from(map['answers'] ?? {}),
      score: map['score'] as int,
      percentage: map['percentage'] as int,
      passed: map['passed'] as bool,
      timeSpentSeconds: map['timeSpentSeconds'] as int,
      startedAt: (map['startedAt'] as Timestamp).toDate(),
      completedAt: (map['completedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'quizId': quizId,
      'conceptId': conceptId,
      'answers': answers,
      'score': score,
      'percentage': percentage,
      'passed': passed,
      'timeSpentSeconds': timeSpentSeconds,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }
}
