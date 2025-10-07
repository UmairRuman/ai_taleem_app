// Path: lib/core/data/repositories/lessons_repository.dart
import 'package:taleem_ai/core/data/collections/lessons_collection.dart';
import 'package:taleem_ai/core/domain/entities/lesson.dart';

class LessonsRepository {
  final LessonsCollection _lessonsCollection = LessonsCollection.instance;

  Future<bool> addLesson(Lesson lesson) async {
    return await _lessonsCollection.addLesson(lesson);
  }

  Future<bool> updateLesson(Lesson lesson) async {
    return await _lessonsCollection.updateLesson(lesson);
  }

  Future<bool> deleteLesson(String lessonId) async {
    return await _lessonsCollection.deleteLesson(lessonId);
  }

  Future<Lesson?> getLesson(String lessonId) async {
    return await _lessonsCollection.getLesson(lessonId);
  }

  Future<List<Lesson>> getAllLessons() async {
    return await _lessonsCollection.getAllLessons();
  }

  Future<List<Lesson>> getLessonsByConcept(String conceptId) async {
    return await _lessonsCollection.getLessonsByConcept(conceptId);
  }

  Future<List<Lesson>> getLessonsByGrade(int grade) async {
    return await _lessonsCollection.getLessonsByGrade(grade);
  }
}
