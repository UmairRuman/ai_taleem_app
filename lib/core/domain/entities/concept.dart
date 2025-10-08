// Path: lib/core/domain/entities/concept.dart
import 'package:taleem_ai/core/domain/entities/content.dart';

class Concept {
  final String conceptId;
  final String title;
  final String? nameUrdu;
  final int gradeLevel;
  final String topic;
  final int order;
  final List<String> prerequisites;
  final Content content; // Changed from Map to Content class
  final String? descriptionUrdu;
  final String difficulty; // "easy" | "medium" | "hard"
  final int estimatedTimeMinutes;

  Concept({
    required this.conceptId,
    required this.title,
    this.nameUrdu,
    required this.gradeLevel,
    required this.topic,
    required this.order,
    required this.prerequisites,
    required this.content,
    this.descriptionUrdu,
    required this.difficulty,
    required this.estimatedTimeMinutes,
  });

  factory Concept.fromMap(Map<String, dynamic> map) {
    return Concept(
      conceptId: map['concept_id'] as String,
      title: map['title'] as String,
      nameUrdu: map['nameUrdu'] as String?,
      gradeLevel: map['grade_level'] as int,
      topic: map['topic'] as String,
      order: map['order'] as int? ?? 0,
      prerequisites: List<String>.from(map['prerequisites'] ?? []),
      content: Content.fromMap(map['content'] as Map<String, dynamic>),
      descriptionUrdu: map['descriptionUrdu'] as String?,
      difficulty: map['difficulty'] as String,
      estimatedTimeMinutes: map['estimatedTimeMinutes'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'concept_id': conceptId,
      'title': title,
      'nameUrdu': nameUrdu,
      'grade_level': gradeLevel,
      'topic': topic,
      'order': order,
      'prerequisites': prerequisites,
      'content': content.toMap(),
      'descriptionUrdu': descriptionUrdu,
      'difficulty': difficulty,
      'estimatedTimeMinutes': estimatedTimeMinutes,
    };
  }
}
