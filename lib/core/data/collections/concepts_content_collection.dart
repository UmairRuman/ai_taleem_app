// lib/core/data/collections/concepts_content_collection.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/concept_content.dart';

/// Collection handler for concepts_content_en and concepts_content_ur
/// Manages language-specific content data
class ConceptsContentCollection {
  final FirebaseFirestore _firestore;
  
  // Collection names for different languages
  static const String englishCollectionName = 'concepts_content_en';
  static const String urduCollectionName = 'concepts_content_ur';

  ConceptsContentCollection({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get collection reference based on language code
  CollectionReference _getCollection(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return _firestore.collection(englishCollectionName);
      case 'ur':
        return _firestore.collection(urduCollectionName);
      default:
        throw ArgumentError('Unsupported language code: $languageCode');
    }
  }

  // ============================================
  // READ OPERATIONS
  // ============================================

  /// Fetch content for a specific concept in a specific language
  Future<ConceptContent?> getContent(
    String conceptId,
    String languageCode,
  ) async {
    try {
      final collection = _getCollection(languageCode);
      final doc = await collection.doc(conceptId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return ConceptContent.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception(
        'Failed to fetch $languageCode content for $conceptId: $e',
      );
    }
  }

  /// Fetch content for multiple concepts (batch fetch)
  /// Useful for preloading content for a grade/topic
  Future<Map<String, ConceptContent>> getContentByIds(
    List<String> conceptIds,
    String languageCode,
  ) async {
    if (conceptIds.isEmpty) return {};

    try {
      final collection = _getCollection(languageCode);
      final results = <String, ConceptContent>{};

      // Firestore 'in' queries limited to 10 items
      final chunks = <List<String>>[];
      for (var i = 0; i < conceptIds.length; i += 10) {
        chunks.add(
          conceptIds.sublist(
            i,
            i + 10 > conceptIds.length ? conceptIds.length : i + 10,
          ),
        );
      }

      for (final chunk in chunks) {
        final snapshot = await collection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in snapshot.docs) {
          results[doc.id] = ConceptContent.fromFirestore(
            doc.data() as Map<String, dynamic>,
          );
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to batch fetch content: $e');
    }
  }

  /// Fetch content in both languages (EN + UR) for a single concept
  Future<({ConceptContent? english, ConceptContent? urdu})> getBothLanguages(
    String conceptId,
  ) async {
    try {
      // Fetch both in parallel for efficiency
      final results = await Future.wait([
        getContent(conceptId, 'en'),
        getContent(conceptId, 'ur'),
      ]);

      return (english: results[0], urdu: results[1]);
    } catch (e) {
      throw Exception('Failed to fetch both languages for $conceptId: $e');
    }
  }

  /// Stream content for real-time updates
  Stream<ConceptContent?> watchContent(
    String conceptId,
    String languageCode,
  ) {
    try {
      final collection = _getCollection(languageCode);
      return collection.doc(conceptId).snapshots().map((doc) {
        if (!doc.exists || doc.data() == null) {
          return null;
        }
        return ConceptContent.fromFirestore(
          doc.data() as Map<String, dynamic>,
        );
      });
    } catch (e) {
      throw Exception('Failed to watch content: $e');
    }
  }

  // ============================================
  // WRITE OPERATIONS (For admin/content management)
  // ============================================

  /// Create new content document
  Future<void> createContent(
    String conceptId,
    ConceptContent content,
    String languageCode,
  ) async {
    try {
      final collection = _getCollection(languageCode);
      await collection.doc(conceptId).set(
            content.toFirestore(),
            SetOptions(merge: false),
          );
    } catch (e) {
      throw Exception('Failed to create content: $e');
    }
  }

  /// Update existing content document
  Future<void> updateContent(
    String conceptId,
    ConceptContent content,
    String languageCode,
  ) async {
    try {
      final collection = _getCollection(languageCode);
      await collection.doc(conceptId).update(content.toFirestore());
    } catch (e) {
      throw Exception('Failed to update content: $e');
    }
  }

  /// Delete content document
  Future<void> deleteContent(
    String conceptId,
    String languageCode,
  ) async {
    try {
      final collection = _getCollection(languageCode);
      await collection.doc(conceptId).delete();
    } catch (e) {
      throw Exception('Failed to delete content: $e');
    }
  }

  /// Delete content in all languages
  Future<void> deleteContentAllLanguages(String conceptId) async {
    try {
      await Future.wait([
        deleteContent(conceptId, 'en'),
        deleteContent(conceptId, 'ur'),
      ]);
    } catch (e) {
      throw Exception('Failed to delete all language content: $e');
    }
  }

  /// Batch create content for multiple concepts
  Future<void> batchCreateContent(
    Map<String, ConceptContent> contentMap,
    String languageCode,
  ) async {
    try {
      final collection = _getCollection(languageCode);
      final batch = _firestore.batch();

      contentMap.forEach((conceptId, content) {
        final docRef = collection.doc(conceptId);
        batch.set(docRef, content.toFirestore());
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch create content: $e');
    }
  }

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Check if content exists for a concept in a language
  Future<bool> exists(String conceptId, String languageCode) async {
    try {
      final collection = _getCollection(languageCode);
      final doc = await collection.doc(conceptId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check content existence: $e');
    }
  }

  /// Get total count of content documents in a language
  Future<int> getCount(String languageCode) async {
    try {
      final collection = _getCollection(languageCode);
      final snapshot = await collection.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get content count: $e');
    }
  }

  /// Check translation completeness
  /// Returns list of concept IDs that have EN but missing UR
  Future<List<String>> getMissingTranslations() async {
    try {
      // Get all English content IDs
      final enSnapshot = await _firestore
          .collection(englishCollectionName)
          .get();
      
      final enIds = enSnapshot.docs.map((doc) => doc.id).toSet();

      // Get all Urdu content IDs
      final urSnapshot = await _firestore
          .collection(urduCollectionName)
          .get();
      
      final urIds = urSnapshot.docs.map((doc) => doc.id).toSet();

      // Find missing translations
      return enIds.difference(urIds).toList();
    } catch (e) {
      throw Exception('Failed to check missing translations: $e');
    }
  }

  /// Get translation progress (percentage)
  Future<double> getTranslationProgress() async {
    try {
      final enCount = await getCount('en');
      if (enCount == 0) return 0.0;

      final urCount = await getCount('ur');
      return (urCount / enCount) * 100;
    } catch (e) {
      throw Exception('Failed to calculate translation progress: $e');
    }
  }
}