// Path: lib/core/domain/entities/recommendation_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationItem {
  final String id;
  final String type; // "review_prerequisite" | "practice_more" | "next_topic"
  final String targetConceptId;
  final String targetLessonId;
  final String reason;
  final String reasonUrdu;
  final String priority; // "high" | "medium" | "low"
  final bool dismissed;
  final DateTime createdAt;
  final DateTime? expiresAt;

  RecommendationItem({
    required this.id,
    required this.type,
    required this.targetConceptId,
    required this.targetLessonId,
    required this.reason,
    required this.reasonUrdu,
    required this.priority,
    required this.dismissed,
    required this.createdAt,
    this.expiresAt,
  });

  factory RecommendationItem.fromMap(Map<String, dynamic> map) {
    return RecommendationItem(
      id: map['id'] as String,
      type: map['type'] as String,
      targetConceptId: map['targetConceptId'] as String,
      targetLessonId: map['targetLessonId'] as String,
      reason: map['reason'] as String,
      reasonUrdu: map['reasonUrdu'] as String,
      priority: map['priority'] as String,
      dismissed: map['dismissed'] as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      expiresAt:
          map['expiresAt'] != null
              ? (map['expiresAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'targetConceptId': targetConceptId,
      'targetLessonId': targetLessonId,
      'reason': reason,
      'reasonUrdu': reasonUrdu,
      'priority': priority,
      'dismissed': dismissed,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }
}
