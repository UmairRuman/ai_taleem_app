// Path: lib/core/presentation/providers/user_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/user.dart';

final userProvider = NotifierProvider<UserStateController, UserStates>(
  UserStateController.new,
);

class UserStateController extends Notifier<UserStates> {
  @override
  UserStates build() {
    return UserInitialState();
  }

  Future<void> getAllUsers() async {
    state = UserLoadingState();
    try {
      final repo = ref.read(userRepositoryProvider);
      final users = await repo.getAllUsers();
      state = UserLoadedState(users: users);
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in getting users: ${e.toString()}");
    }
  }

  Future<void> getUser(String userId) async {
    state = UserLoadingState();
    try {
      final repo = ref.read(userRepositoryProvider);
      final user = await repo.getUser(userId);
      state =
          user != null
              ? UserSingleLoadedState(user: user)
              : UserErrorState(error: 'User not found');
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in getting user: ${e.toString()}");
    }
  }

  Future<void> addUser(User user) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.addUser(user);
      await getAllUsers(); // Refresh list
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in adding user: ${e.toString()}");
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateUser(user);
      await getAllUsers(); // Refresh list
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in updating user: ${e.toString()}");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.deleteUser(userId);
      await getAllUsers(); // Refresh list
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in deleting user: ${e.toString()}");
    }
  }

  Future<void> getUsersByRole(String role) async {
    state = UserLoadingState();
    try {
      final repo = ref.read(userRepositoryProvider);
      final users = await repo.getUsersByRole(role);
      state = UserLoadedState(users: users);
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in getting users by role: ${e.toString()}");
    }
  }

  Future<void> updateLastLogin(String userId, DateTime lastLoginAt) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateLastLogin(userId, lastLoginAt);
      await getUser(userId); // Refresh single user
    } catch (e) {
      state = UserErrorState(error: e.toString());
      log("Error in updating last login: ${e.toString()}");
    }
  }
}

abstract class UserStates {}

class UserInitialState extends UserStates {}

class UserLoadingState extends UserStates {}

class UserLoadedState extends UserStates {
  final List<User> users;
  UserLoadedState({required this.users});
}

class UserSingleLoadedState extends UserStates {
  final User user;
  UserSingleLoadedState({required this.user});
}

class UserErrorState extends UserStates {
  final String error;
  UserErrorState({required this.error});
}
