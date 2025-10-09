import 'package:cloud_firestore/cloud_firestore.dart';

class ConceptProgress {
  final String id; // ADD: Unique ID
  final String userId; // ADD: Link to student
  final String conceptId;
  final String conceptTitle; // ADD: For easy display
  final int gradeLevel; // ADD: For filtering
  final String topic; // ADD: For grouping
  final int masteryLevel; // 0-100
  final int quizAttempts;
  final int quizPasses; // ADD: How many times passed
  final int quizFailures;
  final int bestScore;
  final int averageScore; // ADD: For analytics
  final int totalTimeSpentMinutes; // ADD: Time tracking
  final bool isStruggling;
  final bool isCompleted; // ADD: Mark as done
  final DateTime? completedAt; // ADD: When completed
  final DateTime lastAttemptAt;
  final DateTime createdAt; // ADD: First attempt
  final DateTime updatedAt;

  ConceptProgress({
    required this.id,
    required this.userId,
    required this.conceptId,
    required this.conceptTitle,
    required this.gradeLevel,
    required this.topic,
    required this.masteryLevel,
    required this.quizAttempts,
    required this.quizPasses,
    required this.quizFailures,
    required this.bestScore,
    required this.averageScore,
    required this.totalTimeSpentMinutes,
    required this.isStruggling,
    required this.isCompleted,
    this.completedAt,
    required this.lastAttemptAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConceptProgress.fromMap(Map<String, dynamic> map) {
    return ConceptProgress(
      id: map['id'] as String,
      userId: map['userId'] as String,
      conceptId: map['conceptId'] as String,
      conceptTitle: map['conceptTitle'] as String,
      gradeLevel: map['gradeLevel'] as int,
      topic: map['topic'] as String,
      masteryLevel: map['masteryLevel'] as int,
      quizAttempts: map['quizAttempts'] as int,
      quizPasses: map['quizPasses'] as int? ?? 0,
      quizFailures: map['quizFailures'] as int,
      bestScore: map['bestScore'] as int,
      averageScore: map['averageScore'] as int? ?? 0,
      totalTimeSpentMinutes: map['totalTimeSpentMinutes'] as int? ?? 0,
      isStruggling: map['isStruggling'] as bool,
      isCompleted: map['isCompleted'] as bool? ?? false,
      completedAt:
          map['completedAt'] != null
              ? (map['completedAt'] as Timestamp).toDate()
              : null,
      lastAttemptAt: (map['lastAttemptAt'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'conceptId': conceptId,
      'conceptTitle': conceptTitle,
      'gradeLevel': gradeLevel,
      'topic': topic,
      'masteryLevel': masteryLevel,
      'quizAttempts': quizAttempts,
      'quizPasses': quizPasses,
      'quizFailures': quizFailures,
      'bestScore': bestScore,
      'averageScore': averageScore,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'isStruggling': isStruggling,
      'isCompleted': isCompleted,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'lastAttemptAt': Timestamp.fromDate(lastAttemptAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
