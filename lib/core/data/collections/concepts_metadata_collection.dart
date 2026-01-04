// lib/core/data/collections/concepts_metadata_collection.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/conceptMetadata.dart';


/// Collection handler for concepts_metadata
/// Manages language-independent structural data
class ConceptsMetadataCollection {
  final FirebaseFirestore _firestore;
  static const String collectionName = 'concepts_metadata';

  ConceptsMetadataCollection({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to the collection
  CollectionReference get _collection =>
      _firestore.collection(collectionName);

  // ============================================
  // READ OPERATIONS
  // ============================================

  /// Fetch single concept metadata by ID
  Future<ConceptMetadata?> getMetadata(String conceptId) async {
    try {
      final doc = await _collection.doc(conceptId).get();
      
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return ConceptMetadata.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch metadata for $conceptId: $e');
    }
  }

  /// Fetch all concept metadata (for initial app load)
  /// Returns list sorted by sequenceOrder
  Future<List<ConceptMetadata>> getAllMetadata() async {
    try {
      final snapshot = await _collection
          .orderBy('sequenceOrder')
          .get();

      return snapshot.docs
          .map((doc) => ConceptMetadata.fromFirestore(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all metadata: $e');
    }
  }

  /// Fetch metadata for a specific grade
  Future<List<ConceptMetadata>> getMetadataByGrade(int gradeLevel) async {
    try {
      final snapshot = await _collection
          .where('gradeLevel', isEqualTo: gradeLevel)
          .orderBy('sequenceOrder')
          .get();

      return snapshot.docs
          .map((doc) => ConceptMetadata.fromFirestore(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch metadata for grade $gradeLevel: $e');
    }
  }

  /// Fetch metadata for a specific topic
  Future<List<ConceptMetadata>> getMetadataByTopic(String topic) async {
    try {
      final snapshot = await _collection
          .where('topic', isEqualTo: topic)
          .orderBy('sequenceOrder')
          .get();

      return snapshot.docs
          .map((doc) => ConceptMetadata.fromFirestore(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch metadata for topic $topic: $e');
    }
  }

  /// Fetch metadata for multiple concept IDs (batch fetch)
  Future<List<ConceptMetadata>> getMetadataByIds(
    List<String> conceptIds,
  ) async {
    if (conceptIds.isEmpty) return [];

    try {
      // Firestore 'in' queries are limited to 10 items
      // Split into chunks if needed
      final chunks = <List<String>>[];
      for (var i = 0; i < conceptIds.length; i += 10) {
        chunks.add(
          conceptIds.sublist(
            i,
            i + 10 > conceptIds.length ? conceptIds.length : i + 10,
          ),
        );
      }

      final results = <ConceptMetadata>[];
      for (final chunk in chunks) {
        final snapshot = await _collection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        results.addAll(
          snapshot.docs.map((doc) => ConceptMetadata.fromFirestore(
                doc.data() as Map<String, dynamic>,
              )),
        );
      }

      return results;
    } catch (e) {
      throw Exception('Failed to fetch metadata by IDs: $e');
    }
  }

  /// Fetch concepts with Urdu available
  Future<List<ConceptMetadata>> getMetadataWithUrdu() async {
    try {
      final snapshot = await _collection
          .where('availableLanguages', arrayContains: 'ur')
          .orderBy('sequenceOrder')
          .get();

      return snapshot.docs
          .map((doc) => ConceptMetadata.fromFirestore(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch metadata with Urdu: $e');
    }
  }

  /// Fetch concepts by difficulty level
  Future<List<ConceptMetadata>> getMetadataByDifficulty(
    String difficulty,
  ) async {
    try {
      final snapshot = await _collection
          .where('difficultyLevel', isEqualTo: difficulty)
          .orderBy('sequenceOrder')
          .get();

      return snapshot.docs
          .map((doc) => ConceptMetadata.fromFirestore(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch metadata by difficulty: $e');
    }
  }

  /// Stream single concept metadata (for real-time updates)
  Stream<ConceptMetadata?> watchMetadata(String conceptId) {
    return _collection.doc(conceptId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return ConceptMetadata.fromFirestore(doc.data() as Map<String, dynamic>);
    });
  }

  /// Stream all metadata (for real-time updates)
  Stream<List<ConceptMetadata>> watchAllMetadata() {
    return _collection.orderBy('sequenceOrder').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ConceptMetadata.fromFirestore(
                    doc.data() as Map<String, dynamic>,
                  ))
              .toList(),
        );
  }

  // ============================================
  // WRITE OPERATIONS (For admin/content management)
  // ============================================

  /// Create new concept metadata
  Future<void> createMetadata(ConceptMetadata metadata) async {
    try {
      await _collection.doc(metadata.conceptId).set(
            metadata.toFirestore(),
            SetOptions(merge: false),
          );
    } catch (e) {
      throw Exception('Failed to create metadata: $e');
    }
  }

  /// Update existing concept metadata
  Future<void> updateMetadata(ConceptMetadata metadata) async {
    try {
      await _collection.doc(metadata.conceptId).update(
            metadata.toFirestore(),
          );
    } catch (e) {
      throw Exception('Failed to update metadata: $e');
    }
  }

  /// Delete concept metadata
  Future<void> deleteMetadata(String conceptId) async {
    try {
      await _collection.doc(conceptId).delete();
    } catch (e) {
      throw Exception('Failed to delete metadata: $e');
    }
  }

  /// Batch create multiple metadata documents
  Future<void> batchCreateMetadata(List<ConceptMetadata> metadataList) async {
    try {
      final batch = _firestore.batch();

      for (final metadata in metadataList) {
        final docRef = _collection.doc(metadata.conceptId);
        batch.set(docRef, metadata.toFirestore());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch create metadata: $e');
    }
  }

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Check if concept exists
  Future<bool> exists(String conceptId) async {
    try {
      final doc = await _collection.doc(conceptId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check existence: $e');
    }
  }

  /// Get total count of concepts
  Future<int> getCount() async {
    try {
      final snapshot = await _collection.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get count: $e');
    }
  }

  /// Get count by grade
  Future<int> getCountByGrade(int gradeLevel) async {
    try {
      final snapshot = await _collection
          .where('gradeLevel', isEqualTo: gradeLevel)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get count for grade $gradeLevel: $e');
    }
  }
}