// Path: lib/core/domain/entities/concept.dart

import 'package:taleem_ai/core/domain/entities/quiz.dart';

class Concept {
  final String id;
  final String name;
  final String? nameUrdu;
  final int grade;
  final String topic;
  final int order;
  final List<String> prerequisites;
  final Map<String, dynamic>
  content; // Flexible for introduction, definition, examples, etc.
  final String?
  descriptionUrdu; // Kept for compatibility, but contentUrdu could be added if needed
  final String difficulty; // "easy" | "medium" | "hard"
  final int estimatedTimeMinutes;
  final List<Question> practiceQuizzes; // Embedded quizzes for MVP

  Concept({
    required this.id,
    this.nameUrdu,
    required this.name,
    required this.grade,
    required this.topic,
    required this.order,
    required this.prerequisites,
    required this.content,
    this.descriptionUrdu,
    required this.difficulty,
    required this.estimatedTimeMinutes,
    required this.practiceQuizzes,
  });

  factory Concept.fromMap(Map<String, dynamic> map) {
    return Concept(
      id: map['id'] as String,
      name: map['name'] as String,
      nameUrdu: map['nameUrdu'] as String?,
      grade: map['grade'] as int,
      topic: map['topic'] as String,
      order: map['order'] as int,
      prerequisites: List<String>.from(map['prerequisites'] ?? []),
      content: Map<String, dynamic>.from(map['content'] ?? {}),
      descriptionUrdu: map['descriptionUrdu'] as String?,
      difficulty: map['difficulty'] as String,
      estimatedTimeMinutes: map['estimatedTimeMinutes'] as int,
      practiceQuizzes:
          (map['practiceQuizzes'] as List<dynamic>? ?? [])
              .map((e) => Question.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameUrdu': nameUrdu,
      'grade': grade,
      'topic': topic,
      'order': order,
      'prerequisites': prerequisites,
      'content': content,
      'descriptionUrdu': descriptionUrdu,
      'difficulty': difficulty,
      'estimatedTimeMinutes': estimatedTimeMinutes,
      'practiceQuizzes': practiceQuizzes.map((q) => q.toMap()).toList(),
    };
  }
}
