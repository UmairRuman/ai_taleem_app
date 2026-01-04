// Path: lib/core/data/repositories/concepts_repository.dart
import 'package:taleem_ai/core/data/collections/concepts_collection.dart';
import 'package:taleem_ai/core/domain/entities/concept2.dart';

class ConceptsRepository2 {
  final ConceptsCollection _conceptsCollection = ConceptsCollection.instance;

  Future<bool> addConcept(Concept2 concept) async {
    return await _conceptsCollection.addConcept(concept);
  }

  Future<bool> updateConcept(Concept2 concept) async {
    return await _conceptsCollection.updateConcept(concept);
  }

  Future<bool> deleteConcept(String conceptId) async {
    return await _conceptsCollection.deleteConcept(conceptId);
  }

  Future<Concept2?> getConcept(String conceptId) async {
    return await _conceptsCollection.getConcept(conceptId);
  }

  Future<List<Concept2>> getAllConcepts() async {
    return await _conceptsCollection.getAllConcepts();
  }

  Future<List<Concept2>> getConceptsByGrade(int grade) async {
    return await _conceptsCollection.getConceptsByGrade(grade);
  }

  Future<List<Concept2>> getConceptsByTopic(String topic) async {
    return await _conceptsCollection.getConceptsByTopic(topic);
  }
}
