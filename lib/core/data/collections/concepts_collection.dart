// Path: lib/core/data/collections/concepts_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart'; // Assuming entity path

class ConceptsCollection {
  static final ConceptsCollection instance = ConceptsCollection._internal();
  ConceptsCollection._internal();
  static var conceptsCollection = FirebaseFirestore.instance.collection(
    'concepts',
  );
  factory ConceptsCollection() {
    return instance;
  }

  Future<bool> addConcept(Concept concept) async {
    try {
      await conceptsCollection.doc(concept.id).set(concept.toMap());
      log('Concept added successfully: ${concept.id}');
      return true;
    } catch (e) {
      log("Error adding concept: $e");
      return false;
    }
  }

  Future<bool> updateConcept(Concept concept) async {
    try {
      await conceptsCollection.doc(concept.id).update(concept.toMap());
      log('Concept updated successfully: ${concept.id}');
      return true;
    } catch (e) {
      log("Error updating concept: $e");
      return false;
    }
  }

  Future<bool> deleteConcept(String conceptId) async {
    try {
      await conceptsCollection.doc(conceptId).delete();
      log('Concept deleted successfully: $conceptId');
      return true;
    } catch (e) {
      log("Error deleting concept: $e");
      return false;
    }
  }

  Future<Concept?> getConcept(String conceptId) async {
    try {
      DocumentSnapshot snapshot = await conceptsCollection.doc(conceptId).get();
      if (snapshot.exists) {
        return Concept.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Concept not found: $conceptId');
      return null;
    } catch (e) {
      log("Error getting concept: $e");
      return null;
    }
  }

  Future<List<Concept>> getAllConcepts() async {
    List<Concept> concepts = [];
    try {
      QuerySnapshot snapshot = await conceptsCollection.get();
      for (var doc in snapshot.docs) {
        concepts.add(Concept.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${concepts.length} concepts');
      return concepts;
    } catch (e) {
      log("Error getting all concepts: $e");
      return [];
    }
  }

  // Additional useful method: Get concepts by grade
  Future<List<Concept>> getConceptsByGrade(int grade) async {
    List<Concept> concepts = [];
    try {
      QuerySnapshot snapshot =
          await conceptsCollection.where('grade', isEqualTo: grade).get();
      for (var doc in snapshot.docs) {
        concepts.add(Concept.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${concepts.length} concepts for grade $grade');
      return concepts;
    } catch (e) {
      log("Error getting concepts by grade: $e");
      return [];
    }
  }

  // Additional useful method: Get concepts by topic
  Future<List<Concept>> getConceptsByTopic(String topic) async {
    List<Concept> concepts = [];
    try {
      QuerySnapshot snapshot =
          await conceptsCollection.where('topic', isEqualTo: topic).get();
      for (var doc in snapshot.docs) {
        concepts.add(Concept.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${concepts.length} concepts for topic $topic');
      return concepts;
    } catch (e) {
      log("Error getting concepts by topic: $e");
      return [];
    }
  }
}
