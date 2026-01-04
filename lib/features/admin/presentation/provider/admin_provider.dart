// lib/features/admin/presentation/providers/admin_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/concept2.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadConcepts(List<Concept2> concepts) async {
    final batch = _firestore.batch();

    for (var concept in concepts) {
      final docRef = _firestore.collection('concepts').doc(concept.conceptId);
      batch.set(docRef, concept.toFirestore());
    }

    await batch.commit();
  }

  Future<List<Concept2>> getAllConcepts() async {
    final snapshot =
        await _firestore
            .collection('concepts')
            .orderBy('grade_level')
            .orderBy('sequence_order')
            .get();

    return snapshot.docs.map((doc) => Concept2.fromMap(doc.data())).toList();
  }

  Future<void> deleteConcept(String conceptId) async {
    await _firestore.collection('concepts').doc(conceptId).delete();
  }

  Future<void> updateConcept(
    String conceptId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('concepts').doc(conceptId).update(data);
  }
}
