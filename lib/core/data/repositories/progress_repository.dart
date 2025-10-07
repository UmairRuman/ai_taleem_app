// Path: lib/core/data/repositories/progress_repository.dart
import 'package:taleem_ai/core/data/collections/progress_collection.dart';
import 'package:taleem_ai/core/domain/entities/concept_progress.dart';
import 'package:taleem_ai/core/domain/entities/lesson_progress.dart';

class ProgressRepository {
  final ProgressCollection _progressCollection = ProgressCollection.instance;

  // Lesson Progress Methods
  Future<bool> addLessonProgress(String userId, LessonProgress progress) async {
    return await _progressCollection.addLessonProgress(userId, progress);
  }

  Future<bool> updateLessonProgress(
    String userId,
    LessonProgress progress,
  ) async {
    return await _progressCollection.updateLessonProgress(userId, progress);
  }

  Future<bool> deleteLessonProgress(String userId, String lessonId) async {
    return await _progressCollection.deleteLessonProgress(userId, lessonId);
  }

  Future<LessonProgress?> getLessonProgress(
    String userId,
    String lessonId,
  ) async {
    return await _progressCollection.getLessonProgress(userId, lessonId);
  }

  Future<List<LessonProgress>> getAllLessonProgress(String userId) async {
    return await _progressCollection.getAllLessonProgress(userId);
  }

  // Concept Progress Methods
  Future<bool> addConceptProgress(
    String userId,
    ConceptProgress progress,
  ) async {
    return await _progressCollection.addConceptProgress(userId, progress);
  }

  Future<bool> updateConceptProgress(
    String userId,
    ConceptProgress progress,
  ) async {
    return await _progressCollection.updateConceptProgress(userId, progress);
  }

  Future<bool> deleteConceptProgress(String userId, String conceptId) async {
    return await _progressCollection.deleteConceptProgress(userId, conceptId);
  }

  Future<ConceptProgress?> getConceptProgress(
    String userId,
    String conceptId,
  ) async {
    return await _progressCollection.getConceptProgress(userId, conceptId);
  }

  Future<List<ConceptProgress>> getAllConceptProgress(String userId) async {
    return await _progressCollection.getAllConceptProgress(userId);
  }

  Future<bool> updateMasteryLevel(
    String userId,
    String conceptId,
    int masteryLevel,
  ) async {
    return await _progressCollection.updateMasteryLevel(
      userId,
      conceptId,
      masteryLevel,
    );
  }

  Future<List<ConceptProgress>> getStrugglingConcepts(String userId) async {
    return await _progressCollection.getStrugglingConcepts(userId);
  }
}
