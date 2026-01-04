// ============================================
// 8. COMPLETE CONCEPT (Composite)
// Combines metadata + content for easier use in UI
// ============================================

import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';
import 'package:taleem_ai/core/domain/entities/concept_content.dart';

class Concept {
  final ConceptMetadata metadata;
  final ConceptContent? englishContent;
  final ConceptContent? urduContent;

  Concept({
    required this.metadata,
    this.englishContent,
    this.urduContent,
  });

  // Get content for specific language with fallback
  ConceptContent? getContent(String languageCode) {
    if (languageCode == 'ur' && urduContent != null) {
      return urduContent;
    }
    return englishContent;
  }

  // Get title in specific language
  String getTitle(String languageCode) {
    return getContent(languageCode)?.title ?? 'Untitled';
  }

  // Check if content is loaded for language
  bool hasContentLoaded(String languageCode) {
    if (languageCode == 'ur') {
      return urduContent != null;
    }
    return englishContent != null;
  }

  // Create a copy with updated content
  Concept copyWith({
    ConceptMetadata? metadata,
    ConceptContent? englishContent,
    ConceptContent? urduContent,
  }) {
    return Concept(
      metadata: metadata ?? this.metadata,
      englishContent: englishContent ?? this.englishContent,
      urduContent: urduContent ?? this.urduContent,
    );
  }
}
