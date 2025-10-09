// Path: lib/core/domain/entities/learning_session.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class LearningSession {
  final String id;
  final String userId;
  final String conceptId;
  final String conceptTitle;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSeconds;
  final bool completed;
  final String deviceType; // mobile/tablet/desktop
  final DateTime createdAt;

  LearningSession({
    required this.id,
    required this.userId,
    required this.conceptId,
    required this.conceptTitle,
    required this.startedAt,
    this.endedAt,
    required this.durationSeconds,
    required this.completed,
    required this.deviceType,
    required this.createdAt,
  });

  factory LearningSession.fromMap(Map<String, dynamic> map) {
    return LearningSession(
      id: map['id'] as String,
      userId: map['userId'] as String,
      conceptId: map['conceptId'] as String,
      conceptTitle: map['conceptTitle'] as String,
      startedAt: (map['startedAt'] as Timestamp).toDate(),
      endedAt:
          map['endedAt'] != null
              ? (map['endedAt'] as Timestamp).toDate()
              : null,
      durationSeconds: map['durationSeconds'] as int,
      completed: map['completed'] as bool,
      deviceType: map['deviceType'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'conceptId': conceptId,
      'conceptTitle': conceptTitle,
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
      'durationSeconds': durationSeconds,
      'completed': completed,
      'deviceType': deviceType,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
