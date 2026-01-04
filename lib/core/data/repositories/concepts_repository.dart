// lib/core/data/repositories/concepts_repository.dart

import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';
import 'package:taleem_ai/core/domain/entities/search_indexes.dart';
import '../collections/concepts_metadata_collection.dart';
import '../collections/concepts_content_collection.dart';
import '../collections/search_index_collection.dart';
import '../../domain/entities/concept_content.dart';
import '../../domain/entities/concept.dart';


/// Repository for managing Concept data across three collections
/// Provides a clean API for the presentation layer
class ConceptsRepository {
  final ConceptsMetadataCollection _metadataCollection;
  final ConceptsContentCollection _contentCollection;
  final SearchIndexCollection _searchIndexCollection;

  ConceptsRepository({
    ConceptsMetadataCollection? metadataCollection,
    ConceptsContentCollection? contentCollection,
    SearchIndexCollection? searchIndexCollection,
  })  : _metadataCollection = metadataCollection ?? ConceptsMetadataCollection(),
        _contentCollection = contentCollection ?? ConceptsContentCollection(),
        _searchIndexCollection = searchIndexCollection ?? SearchIndexCollection();

  // ============================================
  // METADATA OPERATIONS
  // ============================================

  /// Get metadata for a single concept
  Future<ConceptMetadata?> getMetadata(String conceptId) async {
    return await _metadataCollection.getMetadata(conceptId);
  }

  /// Get all concept metadata (sorted by sequence)
  Future<List<ConceptMetadata>> getAllMetadata() async {
    return await _metadataCollection.getAllMetadata();
  }

  /// Get metadata for a specific grade
  Future<List<ConceptMetadata>> getMetadataByGrade(int grade) async {
    return await _metadataCollection.getMetadataByGrade(grade);
  }

  /// Get metadata for a specific topic
  Future<List<ConceptMetadata>> getMetadataByTopic(String topic) async {
    return await _metadataCollection.getMetadataByTopic(topic);
  }

  /// Get metadata by difficulty level
  Future<List<ConceptMetadata>> getMetadataByDifficulty(String difficulty) async {
    return await _metadataCollection.getMetadataByDifficulty(difficulty);
  }

  /// Get metadata for concepts with Urdu available
  Future<List<ConceptMetadata>> getMetadataWithUrdu() async {
    return await _metadataCollection.getMetadataWithUrdu();
  }

  /// Get metadata for multiple concept IDs (batch)
  Future<List<ConceptMetadata>> getMetadataByIds(List<String> conceptIds) async {
    return await _metadataCollection.getMetadataByIds(conceptIds);
  }

  /// Stream metadata for real-time updates
  Stream<ConceptMetadata?> watchMetadata(String conceptId) {
    return _metadataCollection.watchMetadata(conceptId);
  }

  /// Stream all metadata for real-time updates
  Stream<List<ConceptMetadata>> watchAllMetadata() {
    return _metadataCollection.watchAllMetadata();
  }

  // ============================================
  // CONTENT OPERATIONS
  // ============================================

  /// Get content for a concept in a specific language
  Future<ConceptContent?> getContent(String conceptId, String languageCode) async {
    return await _contentCollection.getContent(conceptId, languageCode);
  }

  /// Get content for multiple concepts in a specific language (batch)
  Future<Map<String, ConceptContent>> getContentByIds(
    List<String> conceptIds,
    String languageCode,
  ) async {
    return await _contentCollection.getContentByIds(conceptIds, languageCode);
  }

  /// Get content in both EN and UR for a single concept
  Future<({ConceptContent? english, ConceptContent? urdu})> getBothLanguages(
    String conceptId,
  ) async {
    return await _contentCollection.getBothLanguages(conceptId);
  }

  /// Stream content for real-time updates
  Stream<ConceptContent?> watchContent(String conceptId, String languageCode) {
    return _contentCollection.watchContent(conceptId, languageCode);
  }

  // ============================================
  // COMPOSITE CONCEPT OPERATIONS
  // Combines metadata + content for easier UI consumption
  // ============================================

  /// Get a complete Concept (metadata + content in specified language)
  Future<Concept?> getConcept(String conceptId, String languageCode) async {
    try {
      final metadata = await getMetadata(conceptId);
      if (metadata == null) return null;

      final content = await getContent(conceptId, languageCode);

      return Concept(
        metadata: metadata,
        englishContent: languageCode == 'en' ? content : null,
        urduContent: languageCode == 'ur' ? content : null,
      );
    } catch (e) {
      throw Exception('Failed to get concept $conceptId: $e');
    }
  }

  /// Get a complete Concept with both languages loaded
  Future<Concept?> getConceptBothLanguages(String conceptId) async {
    try {
      final metadata = await getMetadata(conceptId);
      if (metadata == null) return null;

      final content = await getBothLanguages(conceptId);

      return Concept(
        metadata: metadata,
        englishContent: content.english,
        urduContent: content.urdu,
      );
    } catch (e) {
      throw Exception('Failed to get concept with both languages: $e');
    }
  }

  /// Get all concepts (metadata only - for list views)
  /// Content should be loaded on-demand when user opens a concept
  Future<List<Concept>> getAllConcepts() async {
    try {
      final metadataList = await getAllMetadata();
      return metadataList.map((metadata) => Concept(metadata: metadata)).toList();
    } catch (e) {
      throw Exception('Failed to get all concepts: $e');
    }
  }

  /// Get concepts by grade (metadata only)
  Future<List<Concept>> getConceptsByGrade(int grade) async {
    try {
      final metadataList = await getMetadataByGrade(grade);
      return metadataList.map((metadata) => Concept(metadata: metadata)).toList();
    } catch (e) {
      throw Exception('Failed to get concepts by grade: $e');
    }
  }

  /// Get concepts by topic (metadata only)
  Future<List<Concept>> getConceptsByTopic(String topic) async {
    try {
      final metadataList = await getMetadataByTopic(topic);
      return metadataList.map((metadata) => Concept(metadata: metadata)).toList();
    } catch (e) {
      throw Exception('Failed to get concepts by topic: $e');
    }
  }

  /// Load content into an existing Concept object
  /// Useful for lazy loading when user opens a concept
  Future<Concept> loadConceptContent(
    Concept concept,
    String languageCode,
  ) async {
    try {
      // If content already loaded, return as is
      if (concept.hasContentLoaded(languageCode)) {
        return concept;
      }

      final content = await getContent(concept.metadata.conceptId, languageCode);

      if (languageCode == 'en') {
        return concept.copyWith(englishContent: content);
      } else {
        return concept.copyWith(urduContent: content);
      }
    } catch (e) {
      throw Exception('Failed to load content: $e');
    }
  }

  /// Preload content for multiple concepts (batch optimization)
  /// Returns map of conceptId -> Concept with content loaded
  Future<Map<String, Concept>> preloadConceptsContent(
    List<Concept> concepts,
    String languageCode,
  ) async {
    try {
      final conceptIds = concepts.map((c) => c.metadata.conceptId).toList();
      final contentMap = await getContentByIds(conceptIds, languageCode);

      final results = <String, Concept>{};
      for (final concept in concepts) {
        final content = contentMap[concept.metadata.conceptId];
        if (content != null) {
          results[concept.metadata.conceptId] = languageCode == 'en'
              ? concept.copyWith(englishContent: content)
              : concept.copyWith(urduContent: content);
        } else {
          results[concept.metadata.conceptId] = concept;
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to preload content: $e');
    }
  }

  // ============================================
  // SEARCH INDEX OPERATIONS
  // ============================================

  /// Get the complete search index (should be cached in app)
  Future<SearchIndex?> getSearchIndex() async {
    return await _searchIndexCollection.getSearchIndex();
  }

  /// Stream search index for real-time updates
  Stream<SearchIndex?> watchSearchIndex() {
    return _searchIndexCollection.watchSearchIndex();
  }

  /// Get concept IDs by grade (using index)
  Future<List<String>> getConceptIdsByGrade(int grade) async {
    return await _searchIndexCollection.getConceptIdsByGrade(grade);
  }

  /// Get concept IDs by topic (using index)
  Future<List<String>> getConceptIdsByTopic(String topic) async {
    return await _searchIndexCollection.getConceptIdsByTopic(topic);
  }

  /// Get concept IDs with Urdu available (using index)
  Future<List<String>> getConceptIdsWithUrdu() async {
    return await _searchIndexCollection.getConceptIdsWithUrdu();
  }

  /// Get filtered concept IDs based on multiple criteria
  Future<List<String>> getFilteredConceptIds({
    int? grade,
    String? topic,
    String? difficulty,
    bool? urduOnly,
  }) async {
    return await _searchIndexCollection.getFilteredConceptIds(
      grade: grade,
      topic: topic,
      difficulty: difficulty,
      urduOnly: urduOnly,
    );
  }

  /// Get filtered concepts (metadata only) based on search index
  /// This is the most efficient way to filter concepts
  Future<List<Concept>> getFilteredConcepts({
    int? grade,
    String? topic,
    String? difficulty,
    bool? urduOnly,
  }) async {
    try {
      final conceptIds = await getFilteredConceptIds(
        grade: grade,
        topic: topic,
        difficulty: difficulty,
        urduOnly: urduOnly,
      );

      if (conceptIds.isEmpty) return [];

      final metadataList = await getMetadataByIds(conceptIds);
      return metadataList.map((metadata) => Concept(metadata: metadata)).toList();
    } catch (e) {
      throw Exception('Failed to get filtered concepts: $e');
    }
  }

  // ============================================
  // ANALYTICS & UTILITIES
  // ============================================

  /// Get available grades
  Future<List<int>> getAvailableGrades() async {
    return await _searchIndexCollection.getAvailableGrades();
  }

  /// Get available topics
  Future<List<String>> getAvailableTopics() async {
    return await _searchIndexCollection.getAvailableTopics();
  }

  /// Get available difficulty levels
  Future<List<String>> getAvailableDifficulties() async {
    return await _searchIndexCollection.getAvailableDifficulties();
  }

  /// Get concept count by grade
  Future<Map<int, int>> getConceptCountByGrade() async {
    return await _searchIndexCollection.getConceptCountByGrade();
  }

  /// Get concept count by topic
  Future<Map<String, int>> getConceptCountByTopic() async {
    return await _searchIndexCollection.getConceptCountByTopic();
  }

  /// Get translation progress percentage
  Future<double> getTranslationProgress() async {
    return await _contentCollection.getTranslationProgress();
  }

  /// Get Urdu coverage percentage
  Future<double> getUrduCoverage() async {
    return await _searchIndexCollection.getUrduCoverage();
  }

  /// Get missing translations (concept IDs with EN but no UR)
  Future<List<String>> getMissingTranslations() async {
    return await _contentCollection.getMissingTranslations();
  }

  /// Check if concept exists
  Future<bool> conceptExists(String conceptId) async {
    return await _metadataCollection.exists(conceptId);
  }

  /// Get total concept count
  Future<int> getTotalConceptCount() async {
    return await _metadataCollection.getCount();
  }

  // ============================================
  // WRITE OPERATIONS (For admin/content management)
  // ============================================

  /// Add a new concept (metadata only)
  Future<bool> addConceptMetadata(ConceptMetadata metadata) async {
    try {
      await _metadataCollection.createMetadata(metadata);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add content for a concept
  Future<bool> addConceptContent(
    String conceptId,
    ConceptContent content,
    String languageCode,
  ) async {
    try {
      await _contentCollection.createContent(conceptId, content, languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update concept metadata
  Future<bool> updateConceptMetadata(ConceptMetadata metadata) async {
    try {
      await _metadataCollection.updateMetadata(metadata);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update concept content
  Future<bool> updateConceptContent(
    String conceptId,
    ConceptContent content,
    String languageCode,
  ) async {
    try {
      await _contentCollection.updateContent(conceptId, content, languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete a concept (metadata + all content)
  Future<bool> deleteConcept(String conceptId) async {
    try {
      // Delete content in all languages first
      await _contentCollection.deleteContentAllLanguages(conceptId);
      // Then delete metadata
      await _metadataCollection.deleteMetadata(conceptId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Batch create concepts (metadata only)
  Future<bool> batchAddMetadata(List<ConceptMetadata> metadataList) async {
    try {
      await _metadataCollection.batchCreateMetadata(metadataList);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Batch create content
  Future<bool> batchAddContent(
    Map<String, ConceptContent> contentMap,
    String languageCode,
  ) async {
    try {
      await _contentCollection.batchCreateContent(contentMap, languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }
}