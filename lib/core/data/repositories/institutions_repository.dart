// Path: lib/core/data/repositories/institutions_repository.dart
import 'package:taleem_ai/core/data/collections/institutions_collection.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';

class InstitutionsRepository {
  final InstitutionsCollection _institutionsCollection =
      InstitutionsCollection.instance;

  Future<bool> addInstitution(Institution institution) async {
    return await _institutionsCollection.addInstitution(institution);
  }

  Future<bool> updateInstitution(Institution institution) async {
    return await _institutionsCollection.updateInstitution(institution);
  }

  Future<bool> deleteInstitution(String institutionId) async {
    return await _institutionsCollection.deleteInstitution(institutionId);
  }

  Future<Institution?> getInstitution(String institutionId) async {
    return await _institutionsCollection.getInstitution(institutionId);
  }

  Future<List<Institution>> getAllInstitutions() async {
    return await _institutionsCollection.getAllInstitutions();
  }

  Future<Institution?> getInstitutionByCode(String code) async {
    return await _institutionsCollection.getInstitutionByCode(code);
  }

  Future<bool> addStudentToInstitution(
    String institutionId,
    String studentId,
  ) async {
    return await _institutionsCollection.addStudentToInstitution(
      institutionId,
      studentId,
    );
  }
}
