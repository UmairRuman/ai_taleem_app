// Path: lib/core/data/collections/lessons_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/lesson.dart'; // Assuming entity path

class LessonsCollection {
  static final LessonsCollection instance = LessonsCollection._internal();
  LessonsCollection._internal();
  static var lessonsCollection = FirebaseFirestore.instance.collection(
    'lessons',
  );
  factory LessonsCollection() {
    return instance;
  }

  Future<bool> addLesson(Lesson lesson) async {
    try {
      await lessonsCollection.doc(lesson.id).set(lesson.toMap());
      log('Lesson added successfully: ${lesson.id}');
      return true;
    } catch (e) {
      log("Error adding lesson: $e");
      return false;
    }
  }

  Future<bool> updateLesson(Lesson lesson) async {
    try {
      await lessonsCollection.doc(lesson.id).update(lesson.toMap());
      log('Lesson updated successfully: ${lesson.id}');
      return true;
    } catch (e) {
      log("Error updating lesson: $e");
      return false;
    }
  }

  Future<bool> deleteLesson(String lessonId) async {
    try {
      await lessonsCollection.doc(lessonId).delete();
      log('Lesson deleted successfully: $lessonId');
      return true;
    } catch (e) {
      log("Error deleting lesson: $e");
      return false;
    }
  }

  Future<Lesson?> getLesson(String lessonId) async {
    try {
      DocumentSnapshot snapshot = await lessonsCollection.doc(lessonId).get();
      if (snapshot.exists) {
        return Lesson.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Lesson not found: $lessonId');
      return null;
    } catch (e) {
      log("Error getting lesson: $e");
      return null;
    }
  }

  Future<List<Lesson>> getAllLessons() async {
    List<Lesson> lessons = [];
    try {
      QuerySnapshot snapshot = await lessonsCollection.get();
      for (var doc in snapshot.docs) {
        lessons.add(Lesson.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${lessons.length} lessons');
      return lessons;
    } catch (e) {
      log("Error getting all lessons: $e");
      return [];
    }
  }

  // Additional useful method: Get lessons by conceptId
  Future<List<Lesson>> getLessonsByConcept(String conceptId) async {
    List<Lesson> lessons = [];
    try {
      QuerySnapshot snapshot =
          await lessonsCollection
              .where('conceptId', isEqualTo: conceptId)
              .get();
      for (var doc in snapshot.docs) {
        lessons.add(Lesson.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${lessons.length} lessons for concept $conceptId');
      return lessons;
    } catch (e) {
      log("Error getting lessons by concept: $e");
      return [];
    }
  }

  // Additional useful method: Get lessons by grade
  Future<List<Lesson>> getLessonsByGrade(int grade) async {
    List<Lesson> lessons = [];
    try {
      QuerySnapshot snapshot =
          await lessonsCollection.where('grade', isEqualTo: grade).get();
      for (var doc in snapshot.docs) {
        lessons.add(Lesson.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${lessons.length} lessons for grade $grade');
      return lessons;
    } catch (e) {
      log("Error getting lessons by grade: $e");
      return [];
    }
  }
}
