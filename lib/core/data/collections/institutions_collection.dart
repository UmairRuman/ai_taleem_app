// Path: lib/features/government_panel/data/datasources/institutions_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';

/// Direct interface for Firestore operations on the 'institutions' collection.
class InstitutionsCollection {
  static final InstitutionsCollection instance =
      InstitutionsCollection._internal();
  InstitutionsCollection._internal();

  // Reference to the 'institutions' Firestore collection
  static final CollectionReference _institutionsCollection = FirebaseFirestore
      .instance
      .collection('institutions');

  factory InstitutionsCollection() {
    return instance;
  }

  /// Adds a new institution to Firestore.
  Future<bool> addInstitution(Institution institution) async {
    try {
      await _institutionsCollection
          .doc(institution.id)
          .set(institution.toMap());
      log('Institution added successfully: ${institution.id}');
      return true;
    } catch (e) {
      log("Error adding institution: $e", error: e);
      return false;
    }
  }

  /// Updates an existing institution in Firestore.
  Future<bool> updateInstitution(Institution institution) async {
    try {
      await _institutionsCollection
          .doc(institution.id)
          .update(institution.toMap());
      log('Institution updated successfully: ${institution.id}');
      return true;
    } catch (e) {
      log("Error updating institution: $e", error: e);
      return false;
    }
  }

  /// Deletes an institution from Firestore by its ID.
  Future<bool> deleteInstitution(String institutionId) async {
    try {
      await _institutionsCollection.doc(institutionId).delete();
      log('Institution deleted successfully: $institutionId');
      return true;
    } catch (e) {
      log("Error deleting institution: $e", error: e);
      return false;
    }
  }

  /// Retrieves a single institution from Firestore by its ID.
  Future<Institution?> getInstitution(String institutionId) async {
    try {
      DocumentSnapshot institutionSnapshot =
          await _institutionsCollection.doc(institutionId).get();
      if (institutionSnapshot.exists) {
        return Institution.fromMap(
          institutionSnapshot.data() as Map<String, dynamic>,
        );
      }
      log('Institution not found: $institutionId');
      return null;
    } catch (e) {
      log("Error getting institution: $e", error: e);
      return null;
    }
  }

  /// Retrieves all institutions from Firestore.
  Future<List<Institution>> getAllInstitutions() async {
    List<Institution> institutions = [];
    try {
      QuerySnapshot institutionSnapshot = await _institutionsCollection.get();
      for (var doc in institutionSnapshot.docs) {
        institutions.add(
          Institution.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${institutions.length} institutions');
      return institutions;
    } catch (e) {
      log("Error getting all institutions: $e", error: e);
      return [];
    }
  }

  /// Retrieves institutions by type (e.g., 'school', 'private').
  Future<List<Institution>> getInstitutionsByType(String type) async {
    List<Institution> institutions = [];
    try {
      QuerySnapshot snapshot =
          await _institutionsCollection.where('type', isEqualTo: type).get();
      for (var doc in snapshot.docs) {
        institutions.add(
          Institution.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${institutions.length} institutions with type: $type');
      return institutions;
    } catch (e) {
      log("Error getting institutions by type: $e", error: e);
      return [];
    }
  }

  /// Retrieves institutions by city.
  Future<List<Institution>> getInstitutionsByCity(String city) async {
    List<Institution> institutions = [];
    try {
      QuerySnapshot snapshot =
          await _institutionsCollection.where('city', isEqualTo: city).get();
      for (var doc in snapshot.docs) {
        institutions.add(
          Institution.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${institutions.length} institutions in city: $city');
      return institutions;
    } catch (e) {
      log("Error getting institutions by city: $e", error: e);
      return [];
    }
  }

  /// Update the active status of an institution.
  Future<bool> updateInstitutionStatus(
    String institutionId,
    bool isActive,
  ) async {
    try {
      await _institutionsCollection.doc(institutionId).update({
        'isActive': isActive,
        'updatedAt': Timestamp.now(), // Update the timestamp as well
      });
      log('Updated active status for institution: $institutionId to $isActive');
      return true;
    } catch (e) {
      log("Error updating institution status: $e", error: e);
      return false;
    }
  }
}
