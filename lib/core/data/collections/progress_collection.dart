// Path: lib/core/data/collections/progress_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/concept_progress.dart'; // Assuming entity path
import 'package:taleem_ai/core/domain/entities/lesson_progress.dart'; // Assuming entity path

class ProgressCollection {
  static final ProgressCollection instance = ProgressCollection._internal();
  ProgressCollection._internal();
  static const String progressCollection = 'progress';
  static const String lessonsSubcollection = 'lessons';
  static const String conceptsSubcollection = 'concepts';
  factory ProgressCollection() {
    return instance;
  }

  // Lesson Progress Methods
  Future<bool> addLessonProgress(String userId, LessonProgress progress) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(lessonsSubcollection)
          .doc(progress.lessonId)
          .set(progress.toMap());
      log(
        'Lesson progress added for user $userId, lesson ${progress.lessonId}',
      );
      return true;
    } catch (e) {
      log("Error adding lesson progress: $e");
      return false;
    }
  }

  Future<bool> updateLessonProgress(
    String userId,
    LessonProgress progress,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(lessonsSubcollection)
          .doc(progress.lessonId)
          .update(progress.toMap());
      log(
        'Lesson progress updated for user $userId, lesson ${progress.lessonId}',
      );
      return true;
    } catch (e) {
      log("Error updating lesson progress: $e");
      return false;
    }
  }

  Future<bool> deleteLessonProgress(String userId, String lessonId) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(lessonsSubcollection)
          .doc(lessonId)
          .delete();
      log('Lesson progress deleted for user $userId, lesson $lessonId');
      return true;
    } catch (e) {
      log("Error deleting lesson progress: $e");
      return false;
    }
  }

  Future<LessonProgress?> getLessonProgress(
    String userId,
    String lessonId,
  ) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(progressCollection)
              .doc(userId)
              .collection(lessonsSubcollection)
              .doc(lessonId)
              .get();
      if (snapshot.exists) {
        return LessonProgress.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Lesson progress not found for user $userId, lesson $lessonId');
      return null;
    } catch (e) {
      log("Error getting lesson progress: $e");
      return null;
    }
  }

  Future<List<LessonProgress>> getAllLessonProgress(String userId) async {
    List<LessonProgress> progresses = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(progressCollection)
              .doc(userId)
              .collection(lessonsSubcollection)
              .get();
      for (var doc in snapshot.docs) {
        progresses.add(
          LessonProgress.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${progresses.length} lesson progresses for user $userId');
      return progresses;
    } catch (e) {
      log("Error getting all lesson progresses: $e");
      return [];
    }
  }

  // Concept Progress Methods
  Future<bool> addConceptProgress(
    String userId,
    ConceptProgress progress,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(conceptsSubcollection)
          .doc(progress.conceptId)
          .set(progress.toMap());
      log(
        'Concept progress added for user $userId, concept ${progress.conceptId}',
      );
      return true;
    } catch (e) {
      log("Error adding concept progress: $e");
      return false;
    }
  }

  Future<bool> updateConceptProgress(
    String userId,
    ConceptProgress progress,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(conceptsSubcollection)
          .doc(progress.conceptId)
          .update(progress.toMap());
      log(
        'Concept progress updated for user $userId, concept ${progress.conceptId}',
      );
      return true;
    } catch (e) {
      log("Error updating concept progress: $e");
      return false;
    }
  }

  Future<bool> deleteConceptProgress(String userId, String conceptId) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(conceptsSubcollection)
          .doc(conceptId)
          .delete();
      log('Concept progress deleted for user $userId, concept $conceptId');
      return true;
    } catch (e) {
      log("Error deleting concept progress: $e");
      return false;
    }
  }

  Future<ConceptProgress?> getConceptProgress(
    String userId,
    String conceptId,
  ) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(progressCollection)
              .doc(userId)
              .collection(conceptsSubcollection)
              .doc(conceptId)
              .get();
      if (snapshot.exists) {
        return ConceptProgress.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Concept progress not found for user $userId, concept $conceptId');
      return null;
    } catch (e) {
      log("Error getting concept progress: $e");
      return null;
    }
  }

  Future<List<ConceptProgress>> getAllConceptProgress(String userId) async {
    List<ConceptProgress> progresses = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(progressCollection)
              .doc(userId)
              .collection(conceptsSubcollection)
              .get();
      for (var doc in snapshot.docs) {
        progresses.add(
          ConceptProgress.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${progresses.length} concept progresses for user $userId');
      return progresses;
    } catch (e) {
      log("Error getting all concept progresses: $e");
      return [];
    }
  }

  // Additional useful method: Update mastery level for concept
  Future<bool> updateMasteryLevel(
    String userId,
    String conceptId,
    int masteryLevel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(progressCollection)
          .doc(userId)
          .collection(conceptsSubcollection)
          .doc(conceptId)
          .update({'masteryLevel': masteryLevel});
      log('Updated mastery level for user $userId, concept $conceptId');
      return true;
    } catch (e) {
      log("Error updating mastery level: $e");
      return false;
    }
  }

  // Additional useful method: Get struggling concepts for user
  Future<List<ConceptProgress>> getStrugglingConcepts(String userId) async {
    List<ConceptProgress> progresses = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(progressCollection)
              .doc(userId)
              .collection(conceptsSubcollection)
              .where('isStruggling', isEqualTo: true)
              .get();
      for (var doc in snapshot.docs) {
        progresses.add(
          ConceptProgress.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${progresses.length} struggling concepts for user $userId');
      return progresses;
    } catch (e) {
      log("Error getting struggling concepts: $e");
      return [];
    }
  }
}
