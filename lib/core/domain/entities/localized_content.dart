// lib/core/domain/entities/localized_content.dart
import 'package:taleem_ai/core/domain/entities/content.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart';

class LocalizedContent {
  final String title;
  final Content content;
  final List<String> keySentences;
  final List<PracticeQuiz> practiceQuiz;

  LocalizedContent({
    required this.title,
    required this.content,
    required this.keySentences,
    required this.practiceQuiz,
  });

  factory LocalizedContent.fromJson(Map<String, dynamic> json) {
    return LocalizedContent(
      title: json['title'] ??= "",
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      keySentences: List<String>.from(json['key_sentences'] ?? []),
      practiceQuiz:
          (json['practice_quiz'] as List<dynamic>?)
              ?.map((e) => PracticeQuiz.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content.toJson(),
      'key_sentences': keySentences,
      'practice_quiz': practiceQuiz.map((e) => e.toMap()).toList(),
    };
  }
}
