import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttempt {
  final String id;
  final String userId;
  final String userName; // ADD: For display
  final String quizId;
  final String conceptId;
  final String conceptTitle; // ADD: For display
  final int gradeLevel; // ADD: For filtering
  final String topic; // ADD: For grouping
  final Map<String, String> answers;
  final Map<String, bool> correctness; // ADD: Track which answers were correct
  final int totalQuestions; // ADD: For percentage calculation
  final int correctAnswers; // ADD: Number of correct answers
  final int score;
  final int percentage;
  final bool passed;
  final int timeSpentSeconds;
  final String difficulty; // ADD: easy/medium/hard
  final DateTime startedAt;
  final DateTime completedAt;
  final DateTime createdAt; // ADD: For sorting

  QuizAttempt({
    required this.id,
    required this.userId,
    required this.userName,
    required this.quizId,
    required this.conceptId,
    required this.conceptTitle,
    required this.gradeLevel,
    required this.topic,
    required this.answers,
    required this.correctness,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.percentage,
    required this.passed,
    required this.timeSpentSeconds,
    required this.difficulty,
    required this.startedAt,
    required this.completedAt,
    required this.createdAt,
  });

  factory QuizAttempt.fromMap(Map<String, dynamic> map) {
    return QuizAttempt(
      id: map['id'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      quizId: map['quizId'] as String,
      conceptId: map['conceptId'] as String,
      conceptTitle: map['conceptTitle'] as String,
      gradeLevel: map['gradeLevel'] as int,
      topic: map['topic'] as String,
      answers: Map<String, String>.from(map['answers'] ?? {}),
      correctness: Map<String, bool>.from(map['correctness'] ?? {}),
      totalQuestions: map['totalQuestions'] as int,
      correctAnswers: map['correctAnswers'] as int,
      score: map['score'] as int,
      percentage: map['percentage'] as int,
      passed: map['passed'] as bool,
      timeSpentSeconds: map['timeSpentSeconds'] as int,
      difficulty: map['difficulty'] as String,
      startedAt: (map['startedAt'] as Timestamp).toDate(),
      completedAt: (map['completedAt'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'quizId': quizId,
      'conceptId': conceptId,
      'conceptTitle': conceptTitle,
      'gradeLevel': gradeLevel,
      'topic': topic,
      'answers': answers,
      'correctness': correctness,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'score': score,
      'percentage': percentage,
      'passed': passed,
      'timeSpentSeconds': timeSpentSeconds,
      'difficulty': difficulty,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt': Timestamp.fromDate(completedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
