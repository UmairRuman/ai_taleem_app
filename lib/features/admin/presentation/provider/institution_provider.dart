// Path: lib/features/government_panel/presentation/providers/institution_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart'; // Ensure this path is correct for your DI setup
import 'package:taleem_ai/core/domain/entities/institution.dart';

/// Provider for InstitutionStateController.
final institutionProvider =
    NotifierProvider<InstitutionStateController, InstitutionStates>(
      InstitutionStateController.new,
    );

/// State management controller for Institutions.
class InstitutionStateController extends Notifier<InstitutionStates> {
  @override
  InstitutionStates build() {
    return InstitutionInitialState();
  }

  /// Fetches all institutions.
  Future<void> getAllInstitutions() async {
    state = InstitutionLoadingState();
    try {
      final repo = ref.read(
        institutionRepositoryProvider,
      ); // Assuming you'll define this in injection_container.dart
      final institutions = await repo.getAllInstitutions();
      state = InstitutionLoadedState(institutions: institutions);
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log("Error in getting all institutions: $e", error: e, stackTrace: st);
    }
  }

  /// Fetches a single institution by ID.
  Future<void> getInstitution(String institutionId) async {
    state = InstitutionLoadingState();
    try {
      final repo = ref.read(institutionRepositoryProvider);
      final institution = await repo.getInstitution(institutionId);
      state =
          institution != null
              ? InstitutionSingleLoadedState(institution: institution)
              : InstitutionErrorState(error: 'Institution not found');
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log("Error in getting institution: $e", error: e, stackTrace: st);
    }
  }

  /// Adds a new institution.
  Future<void> addInstitution(Institution institution) async {
    state = InstitutionLoadingState(); // Optional: show loading during add
    try {
      final repo = ref.read(institutionRepositoryProvider);
      await repo.addInstitution(institution);
      await getAllInstitutions(); // Refresh list after adding
      state = InstitutionActionSuccessState(
        message: 'Institution added successfully!',
      );
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log("Error in adding institution: $e", error: e, stackTrace: st);
    }
  }

  /// Updates an existing institution.
  Future<void> updateInstitution(Institution institution) async {
    state = InstitutionLoadingState(); // Optional: show loading during update
    try {
      final repo = ref.read(institutionRepositoryProvider);
      await repo.updateInstitution(institution);
      await getAllInstitutions(); // Refresh list after updating
      state = InstitutionActionSuccessState(
        message: 'Institution updated successfully!',
      );
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log("Error in updating institution: $e", error: e, stackTrace: st);
    }
  }

  /// Deletes an institution.
  Future<void> deleteInstitution(String institutionId) async {
    state = InstitutionLoadingState(); // Optional: show loading during delete
    try {
      final repo = ref.read(institutionRepositoryProvider);
      await repo.deleteInstitution(institutionId);
      await getAllInstitutions(); // Refresh list after deleting
      state = InstitutionActionSuccessState(
        message: 'Institution deleted successfully!',
      );
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log("Error in deleting institution: $e", error: e, stackTrace: st);
    }
  }

  /// Fetches institutions by type.
  Future<void> getInstitutionsByType(String type) async {
    state = InstitutionLoadingState();
    try {
      final repo = ref.read(institutionRepositoryProvider);
      final institutions = await repo.getInstitutionsByType(type);
      state = InstitutionLoadedState(institutions: institutions);
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log(
        "Error in getting institutions by type: $e",
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Fetches institutions by city.
  Future<void> getInstitutionsByCity(String city) async {
    state = InstitutionLoadingState();
    try {
      final repo = ref.read(institutionRepositoryProvider);
      final institutions = await repo.getInstitutionsByCity(city);
      state = InstitutionLoadedState(institutions: institutions);
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log(
        "Error in getting institutions by city: $e",
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Updates the active status of an institution.
  Future<void> updateInstitutionStatus(
    String institutionId,
    bool isActive,
  ) async {
    state =
        InstitutionLoadingState(); // Optional: show loading during status update
    try {
      final repo = ref.read(institutionRepositoryProvider);
      await repo.updateInstitutionStatus(institutionId, isActive);
      await getAllInstitutions(); // Refresh list after status update
      state = InstitutionActionSuccessState(
        message: 'Institution status updated successfully!',
      );
    } catch (e, st) {
      state = InstitutionErrorState(error: e.toString());
      log("Error in updating institution status: $e", error: e, stackTrace: st);
    }
  }
}

// --- Institution States (similar to your UserStates) ---
abstract class InstitutionStates {}

class InstitutionInitialState extends InstitutionStates {}

class InstitutionLoadingState extends InstitutionStates {}

class InstitutionLoadedState extends InstitutionStates {
  final List<Institution> institutions;
  InstitutionLoadedState({required this.institutions});
}

class InstitutionSingleLoadedState extends InstitutionStates {
  final Institution institution;
  InstitutionSingleLoadedState({required this.institution});
}

class InstitutionErrorState extends InstitutionStates {
  final String error;
  InstitutionErrorState({required this.error});
}

class InstitutionActionSuccessState extends InstitutionStates {
  final String message;
  InstitutionActionSuccessState({required this.message});
}
