// Path: lib/core/data/collections/institutions_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart'; // Assuming entity path

class InstitutionsCollection {
  static final InstitutionsCollection instance =
      InstitutionsCollection._internal();
  InstitutionsCollection._internal();
  static var institutionsCollection = FirebaseFirestore.instance.collection(
    'institutions',
  );
  factory InstitutionsCollection() {
    return instance;
  }

  Future<bool> addInstitution(Institution institution) async {
    try {
      await institutionsCollection.doc(institution.id).set(institution.toMap());
      log('Institution added successfully: ${institution.id}');
      return true;
    } catch (e) {
      log("Error adding institution: $e");
      return false;
    }
  }

  Future<bool> updateInstitution(Institution institution) async {
    try {
      await institutionsCollection
          .doc(institution.id)
          .update(institution.toMap());
      log('Institution updated successfully: ${institution.id}');
      return true;
    } catch (e) {
      log("Error updating institution: $e");
      return false;
    }
  }

  Future<bool> deleteInstitution(String institutionId) async {
    try {
      await institutionsCollection.doc(institutionId).delete();
      log('Institution deleted successfully: $institutionId');
      return true;
    } catch (e) {
      log("Error deleting institution: $e");
      return false;
    }
  }

  Future<Institution?> getInstitution(String institutionId) async {
    try {
      DocumentSnapshot snapshot =
          await institutionsCollection.doc(institutionId).get();
      if (snapshot.exists) {
        return Institution.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      log('Institution not found: $institutionId');
      return null;
    } catch (e) {
      log("Error getting institution: $e");
      return null;
    }
  }

  Future<List<Institution>> getAllInstitutions() async {
    List<Institution> institutions = [];
    try {
      QuerySnapshot snapshot = await institutionsCollection.get();
      for (var doc in snapshot.docs) {
        institutions.add(
          Institution.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${institutions.length} institutions');
      return institutions;
    } catch (e) {
      log("Error getting all institutions: $e");
      return [];
    }
  }

  // Additional useful method: Get institution by code (since code is unique)
  Future<Institution?> getInstitutionByCode(String code) async {
    try {
      QuerySnapshot snapshot =
          await institutionsCollection
              .where('code', isEqualTo: code)
              .limit(1)
              .get();
      if (snapshot.docs.isNotEmpty) {
        return Institution.fromMap(
          snapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      log('Institution not found for code: $code');
      return null;
    } catch (e) {
      log("Error getting institution by code: $e");
      return null;
    }
  }

  // Additional useful method: Add student to institution
  Future<bool> addStudentToInstitution(
    String institutionId,
    String studentId,
  ) async {
    try {
      await institutionsCollection.doc(institutionId).update({
        'studentIds': FieldValue.arrayUnion([studentId]),
      });
      log('Added student $studentId to institution $institutionId');
      return true;
    } catch (e) {
      log("Error adding student to institution: $e");
      return false;
    }
  }
}
