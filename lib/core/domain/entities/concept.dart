// lib/core/domain/entities/concept.dart
import 'package:taleem_ai/core/domain/entities/quiz.dart';
import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';

import 'content.dart';

class Concept {
  final String conceptId;
  final int gradeLevel;
  final String title;
  final int sequenceOrder;
  final List<String> prerequisites;
  final List<TeacherRemediationTip> teacherRemediationTip;
  final List<String> definesGlossaryTerms;
  final Content content;
  final List<String> images;
  final List<dynamic> interactiveElements;
  final List<String> keySentences;
  final List<PracticeQuiz> practiceQuiz;

  // Additional fields for our system
  final String? nameUrdu;
  final String? descriptionUrdu;
  final String topic;
  final String difficulty;
  final int estimatedTimeMinutes;

  Concept({
    required this.conceptId,
    required this.gradeLevel,
    required this.title,
    required this.sequenceOrder,
    required this.prerequisites,
    required this.teacherRemediationTip,
    required this.definesGlossaryTerms,
    required this.content,
    required this.images,
    required this.interactiveElements,
    required this.keySentences,
    required this.practiceQuiz,
    this.nameUrdu,
    this.descriptionUrdu,
    this.topic = 'sets',
    this.difficulty = 'medium',
    this.estimatedTimeMinutes = 15,
  });

  factory Concept.fromMap(Map<String, dynamic> json) {
    return Concept(
      conceptId: json['concept_id'] as String,
      gradeLevel: json['grade_level'] as int,
      title: json['title'] as String,
      sequenceOrder: json['sequence_order'] as int,
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      teacherRemediationTip:
          (json['teacher_remediation_tip'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TeacherRemediationTip.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      definesGlossaryTerms: List<String>.from(
        json['defines_glossary_terms'] ?? [],
      ),
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      images: List<String>.from(json['images'] ?? []),
      interactiveElements: json['interactive_elements'] as List<dynamic>? ?? [],
      keySentences: List<String>.from(json['key_sentences'] ?? []),
      practiceQuiz:
          (json['practice_quiz'] as List<dynamic>?)
              ?.map((e) => PracticeQuiz.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      nameUrdu: json['nameUrdu'] as String?,
      descriptionUrdu: json['descriptionUrdu'] as String?,
      topic: json['topic'] as String? ?? 'sets',
      difficulty: json['difficulty'] as String? ?? 'medium',
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'concept_id': conceptId,
      'grade_level': gradeLevel,
      'title': title,
      'sequence_order': sequenceOrder,
      'prerequisites': prerequisites,
      'teacher_remediation_tip':
          teacherRemediationTip.map((e) => e.toJson()).toList(),
      'defines_glossary_terms': definesGlossaryTerms,
      'content': content.toJson(),
      'images': images,
      'interactive_elements': interactiveElements,
      'key_sentences': keySentences,
      'practice_quiz': practiceQuiz.map((e) => e.toMap()).toList(),
      if (nameUrdu != null) 'nameUrdu': nameUrdu,
      if (descriptionUrdu != null) 'descriptionUrdu': descriptionUrdu,
      'topic': topic,
      'difficulty': difficulty,
      'estimatedTimeMinutes': estimatedTimeMinutes,
    };
  }

  // For Firestore (snake_case keys)
  Map<String, dynamic> toFirestore() {
    return {
      'concept_id': conceptId,
      'grade_level': gradeLevel,
      'title': title,
      'title_urdu': nameUrdu,
      'sequence_order': sequenceOrder,
      'prerequisites': prerequisites,
      'teacher_remediation_tip':
          teacherRemediationTip.map((e) => e.toJson()).toList(),
      'defines_glossary_terms': definesGlossaryTerms,
      'content': content.toJson(),
      'images': images,
      'interactive_elements': interactiveElements,
      'key_sentences': keySentences,
      'practice_quiz': practiceQuiz.map((e) => e.toMap()).toList(),
      'description_urdu': descriptionUrdu,
      'topic': topic,
      'difficulty': difficulty,
      'estimated_time_minutes': estimatedTimeMinutes,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}
