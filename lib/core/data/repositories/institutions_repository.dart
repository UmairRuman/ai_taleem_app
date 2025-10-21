// Path: lib/features/government_panel/data/repositories/institution_repository.dart
import 'package:taleem_ai/core/data/collections/institutions_collection.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';

/// Repository for managing Institution data.
class InstitutionRepository {
  final InstitutionsCollection _institutionsCollection;

  InstitutionRepository(this._institutionsCollection);

  /// Adds a new institution.
  Future<bool> addInstitution(Institution institution) async {
    return await _institutionsCollection.addInstitution(institution);
  }

  /// Updates an existing institution.
  Future<bool> updateInstitution(Institution institution) async {
    return await _institutionsCollection.updateInstitution(institution);
  }

  /// Deletes an institution by ID.
  Future<bool> deleteInstitution(String institutionId) async {
    return await _institutionsCollection.deleteInstitution(institutionId);
  }

  /// Retrieves a single institution by ID.
  Future<Institution?> getInstitution(String institutionId) async {
    return await _institutionsCollection.getInstitution(institutionId);
  }

  /// Retrieves all institutions.
  Future<List<Institution>> getAllInstitutions() async {
    return await _institutionsCollection.getAllInstitutions();
  }

  /// Retrieves institutions by type.
  Future<List<Institution>> getInstitutionsByType(String type) async {
    return await _institutionsCollection.getInstitutionsByType(type);
  }

  /// Retrieves institutions by city.
  Future<List<Institution>> getInstitutionsByCity(String city) async {
    return await _institutionsCollection.getInstitutionsByCity(city);
  }

  /// Updates the active status of an institution.
  Future<bool> updateInstitutionStatus(
    String institutionId,
    bool isActive,
  ) async {
    return await _institutionsCollection.updateInstitutionStatus(
      institutionId,
      isActive,
    );
  }
}
