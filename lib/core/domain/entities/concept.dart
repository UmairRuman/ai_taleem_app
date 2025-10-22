// lib/core/domain/entities/concept.dart
import 'package:taleem_ai/core/domain/entities/content.dart';
import 'package:taleem_ai/core/domain/entities/localized_content.dart';
import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';

class Concept {
  final String conceptId;
  final int gradeLevel;
  final int sequenceOrder;
  final List<String> prerequisites;
  final List<TeacherRemediationTip> teacherRemediationTip;
  final List<String> definesGlossaryTerms;

  // Language-independent fields
  final List<String> images;
  final List<dynamic> interactiveElements;

  // Localized content for multiple languages
  final Map<String, LocalizedContent> localizedContent;

  // Additional fields for our system
  final String topic;
  final String difficulty;
  final int estimatedTimeMinutes;

  Concept({
    required this.conceptId,
    required this.gradeLevel,
    required this.sequenceOrder,
    required this.prerequisites,
    required this.teacherRemediationTip,
    required this.definesGlossaryTerms,
    required this.localizedContent,
    required this.images,
    required this.interactiveElements,
    this.topic = 'sets',
    this.difficulty = 'medium',
    this.estimatedTimeMinutes = 15,
  });

  // Get content for specific language, fallback to English
  LocalizedContent getContent(String languageCode) {
    return localizedContent[languageCode] ?? localizedContent['en']!;
  }

  // Get title in specific language
  String getTitle(String languageCode) {
    return getContent(languageCode).title;
  }

  // Get all text content in specific language
  Content getContentData(String languageCode) {
    return getContent(languageCode).content;
  }

  factory Concept.fromMap(Map<String, dynamic> json) {
    // Parse localized content
    Map<String, LocalizedContent> localizedContentMap = {};

    if (json['localized_content'] != null) {
      final localizedData = json['localized_content'] as Map<String, dynamic>;
      localizedData.forEach((languageCode, contentData) {
        localizedContentMap[languageCode] = LocalizedContent.fromJson(
          contentData as Map<String, dynamic>,
        );
      });
    }

    return Concept(
      conceptId: json['concept_id'] as String,
      gradeLevel: json['grade_level'] as int,
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
      localizedContent: localizedContentMap,
      images: List<String>.from(json['images'] ?? []),
      interactiveElements: json['interactive_elements'] as List<dynamic>? ?? [],
      topic: json['topic'] as String? ?? 'sets',
      difficulty: json['difficulty'] as String? ?? 'medium',
      estimatedTimeMinutes: json['estimated_time_minutes'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'concept_id': conceptId,
      'grade_level': gradeLevel,
      'sequence_order': sequenceOrder,
      'prerequisites': prerequisites,
      'teacher_remediation_tip':
          teacherRemediationTip.map((e) => e.toJson()).toList(),
      'defines_glossary_terms': definesGlossaryTerms,
      'localized_content': localizedContent.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'images': images,
      'interactive_elements': interactiveElements,
      'topic': topic,
      'difficulty': difficulty,
      'estimated_time_minutes': estimatedTimeMinutes,
    };
  }

  // For Firestore (snake_case keys)
  Map<String, dynamic> toFirestore() {
    return {
      'concept_id': conceptId,
      'grade_level': gradeLevel,
      'sequence_order': sequenceOrder,
      'prerequisites': prerequisites,
      'teacher_remediation_tip':
          teacherRemediationTip.map((e) => e.toJson()).toList(),
      'defines_glossary_terms': definesGlossaryTerms,
      'localized_content': localizedContent.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'images': images,
      'interactive_elements': interactiveElements,
      'topic': topic,
      'difficulty': difficulty,
      'estimated_time_minutes': estimatedTimeMinutes,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}
