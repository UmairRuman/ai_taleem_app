// Path: lib/core/presentation/providers/institutions_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';

final institutionsProvider =
    NotifierProvider<InstitutionsStateController, InstitutionsStates>(
      InstitutionsStateController.new,
    );

class InstitutionsStateController extends Notifier<InstitutionsStates> {
  @override
  InstitutionsStates build() {
    return InstitutionsInitialState();
  }

  Future<void> getAllInstitutions() async {
    state = InstitutionsLoadingState();
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      final institutions = await repo.getAllInstitutions();
      state = InstitutionsLoadedState(institutions: institutions);
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in getting institutions: ${e.toString()}");
    }
  }

  Future<void> getInstitution(String institutionId) async {
    state = InstitutionsLoadingState();
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      final institution = await repo.getInstitution(institutionId);
      state =
          institution != null
              ? InstitutionsSingleLoadedState(institution: institution)
              : InstitutionsErrorState(error: 'Institution not found');
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in getting institution: ${e.toString()}");
    }
  }

  Future<void> addInstitution(Institution institution) async {
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      await repo.addInstitution(institution);
      await getAllInstitutions(); // Refresh list
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in adding institution: ${e.toString()}");
    }
  }

  Future<void> updateInstitution(Institution institution) async {
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      await repo.updateInstitution(institution);
      await getAllInstitutions(); // Refresh list
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in updating institution: ${e.toString()}");
    }
  }

  Future<void> deleteInstitution(String institutionId) async {
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      await repo.deleteInstitution(institutionId);
      await getAllInstitutions(); // Refresh list
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in deleting institution: ${e.toString()}");
    }
  }

  Future<void> getInstitutionByCode(String code) async {
    state = InstitutionsLoadingState();
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      final institution = await repo.getInstitutionByCode(code);
      state =
          institution != null
              ? InstitutionsSingleLoadedState(institution: institution)
              : InstitutionsErrorState(error: 'Institution not found');
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in getting institution by code: ${e.toString()}");
    }
  }

  Future<void> addStudentToInstitution(
    String institutionId,
    String studentId,
  ) async {
    try {
      final repo = ref.read(institutionsRepositoryProvider);
      await repo.addStudentToInstitution(institutionId, studentId);
      await getInstitution(institutionId); // Refresh single
    } catch (e) {
      state = InstitutionsErrorState(error: e.toString());
      log("Error in adding student to institution: ${e.toString()}");
    }
  }
}

abstract class InstitutionsStates {}

class InstitutionsInitialState extends InstitutionsStates {}

class InstitutionsLoadingState extends InstitutionsStates {}

class InstitutionsLoadedState extends InstitutionsStates {
  final List<Institution> institutions;
  InstitutionsLoadedState({required this.institutions});
}

class InstitutionsSingleLoadedState extends InstitutionsStates {
  final Institution institution;
  InstitutionsSingleLoadedState({required this.institution});
}

class InstitutionsErrorState extends InstitutionsStates {
  final String error;
  InstitutionsErrorState({required this.error});
}
