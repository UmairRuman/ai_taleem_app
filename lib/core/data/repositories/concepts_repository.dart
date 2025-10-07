// Path: lib/core/data/repositories/concepts_repository.dart
import 'package:taleem_ai/core/data/collections/concepts_collection.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart';

class ConceptsRepository {
  final ConceptsCollection _conceptsCollection = ConceptsCollection.instance;

  Future<bool> addConcept(Concept concept) async {
    return await _conceptsCollection.addConcept(concept);
  }

  Future<bool> updateConcept(Concept concept) async {
    return await _conceptsCollection.updateConcept(concept);
  }

  Future<bool> deleteConcept(String conceptId) async {
    return await _conceptsCollection.deleteConcept(conceptId);
  }

  Future<Concept?> getConcept(String conceptId) async {
    return await _conceptsCollection.getConcept(conceptId);
  }

  Future<List<Concept>> getAllConcepts() async {
    return await _conceptsCollection.getAllConcepts();
  }

  Future<List<Concept>> getConceptsByGrade(int grade) async {
    return await _conceptsCollection.getConceptsByGrade(grade);
  }

  Future<List<Concept>> getConceptsByTopic(String topic) async {
    return await _conceptsCollection.getConceptsByTopic(topic);
  }
}
