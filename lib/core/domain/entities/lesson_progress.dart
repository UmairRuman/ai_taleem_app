// Path: lib/core/domain/entities/lesson_progress.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonProgress {
  final String lessonId;
  final String conceptId;
  final String status; // "not_started" | "in_progress" | "completed"
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final int timeSpentSeconds;

  LessonProgress({
    required this.lessonId,
    required this.conceptId,
    required this.status,
    this.startedAt,
    this.completedAt,
    required this.lastAccessedAt,
    required this.timeSpentSeconds,
  });

  factory LessonProgress.fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      lessonId: map['lessonId'] as String,
      conceptId: map['conceptId'] as String,
      status: map['status'] as String,
      startedAt:
          map['startedAt'] != null
              ? (map['startedAt'] as Timestamp).toDate()
              : null,
      completedAt:
          map['completedAt'] != null
              ? (map['completedAt'] as Timestamp).toDate()
              : null,
      lastAccessedAt: (map['lastAccessedAt'] as Timestamp).toDate(),
      timeSpentSeconds: map['timeSpentSeconds'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'conceptId': conceptId,
      'status': status,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
      'timeSpentSeconds': timeSpentSeconds,
    };
  }
}
