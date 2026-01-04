// ============================================
// 2. CONCEPT CONTENT (concepts_content_en/ur)
// Language-specific content data
// ============================================

import 'package:taleem_ai/core/domain/entities/content_block.dart';
import 'package:taleem_ai/core/domain/entities/interactive_element.dart';
import 'package:taleem_ai/core/domain/entities/practice_quiz_question.dart';

class ConceptContent {
  final String title;
  final List<String> teacherRemediationTip;
  final ContentBlock content;
  final List<String> images;
  final List<InteractiveElement> interactiveElements;
  final List<String> keySentences;
  final List<PracticeQuizQuestion> practiceQuiz;

  ConceptContent({
    required this.title,
    required this.teacherRemediationTip,
    required this.content,
    required this.images,
    required this.interactiveElements,
    required this.keySentences,
    required this.practiceQuiz,
  });

  factory ConceptContent.fromFirestore(Map<String, dynamic> json) {
    return ConceptContent(
      title: json['title'] as String? ?? '',
      teacherRemediationTip: List<String>.from(
        json['teacherRemediationTip'] ?? [],
      ),
      content: ContentBlock.fromJson(
        json['content'] as Map<String, dynamic>? ?? {},
      ),
      images: List<String>.from(json['images'] ?? []),
      interactiveElements: (json['interactiveElements'] as List<dynamic>?)
          ?.map((e) => InteractiveElement.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      keySentences: List<String>.from(json['keySentences'] ?? []),
      practiceQuiz: (json['practiceQuiz'] as List<dynamic>?)
          ?.map((e) => PracticeQuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'teacherRemediationTip': teacherRemediationTip,
      'content': content.toJson(),
      'images': images,
      'interactiveElements': interactiveElements.map((e) => e.toJson()).toList(),
      'keySentences': keySentences,
      'practiceQuiz': practiceQuiz.map((e) => e.toJson()).toList(),
    };
  }
}