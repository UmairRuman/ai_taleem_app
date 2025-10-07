// Path: lib/core/domain/entities/concept_progress.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ConceptProgress {
  final String conceptId;
  final int masteryLevel;
  final int quizAttempts;
  final int quizFailures;
  final int bestScore;
  final bool isStruggling;
  final DateTime lastAttemptAt;
  final DateTime updatedAt;

  ConceptProgress({
    required this.conceptId,
    required this.masteryLevel,
    required this.quizAttempts,
    required this.quizFailures,
    required this.bestScore,
    required this.isStruggling,
    required this.lastAttemptAt,
    required this.updatedAt,
  });

  factory ConceptProgress.fromMap(Map<String, dynamic> map) {
    return ConceptProgress(
      conceptId: map['conceptId'] as String,
      masteryLevel: map['masteryLevel'] as int,
      quizAttempts: map['quizAttempts'] as int,
      quizFailures: map['quizFailures'] as int,
      bestScore: map['bestScore'] as int,
      isStruggling: map['isStruggling'] as bool,
      lastAttemptAt: (map['lastAttemptAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conceptId': conceptId,
      'masteryLevel': masteryLevel,
      'quizAttempts': quizAttempts,
      'quizFailures': quizFailures,
      'bestScore': bestScore,
      'isStruggling': isStruggling,
      'lastAttemptAt': Timestamp.fromDate(lastAttemptAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
