// ============================================
// 3. CONTENT BLOCK
// Main pedagogical content structure
// ============================================

import 'package:taleem_ai/core/domain/entities/common_mistake.dart';
import 'package:taleem_ai/core/domain/entities/concept_example.dart';

class ContentBlock {
  final String introduction;
  final String definition;
  final List<String> keyPoints;
  final List<ConceptExample> examples;
  final List<CommonMistake> commonMistakes;
  final String summary;

  ContentBlock({
    required this.introduction,
    required this.definition,
    required this.keyPoints,
    required this.examples,
    required this.commonMistakes,
    required this.summary,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      introduction: json['introduction'] as String? ?? '',
      definition: json['definition'] as String? ?? '',
      keyPoints: List<String>.from(json['keyPoints'] ?? []),
      examples: (json['examples'] as List<dynamic>?)
          ?.map((e) => ConceptExample.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)
          ?.map((e) => CommonMistake.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      summary: json['summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'introduction': introduction,
      'definition': definition,
      'keyPoints': keyPoints,
      'examples': examples.map((e) => e.toJson()).toList(),
      'commonMistakes': commonMistakes.map((e) => e.toJson()).toList(),
      'summary': summary,
    };
  }
}
