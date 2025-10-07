// Path: lib/core/data/collections/users_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/user.dart'; // Assuming entity path

class UsersCollection {
  static final UsersCollection instance = UsersCollection._internal();
  UsersCollection._internal();
  static var usersCollection = FirebaseFirestore.instance.collection('users');
  factory UsersCollection() {
    return instance;
  }

  Future<bool> addUser(User user) async {
    try {
      await usersCollection.doc(user.id).set(user.toMap());
      log('User added successfully: ${user.id}');
      return true;
    } catch (e) {
      log("Error adding user: $e");
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      await usersCollection.doc(user.id).update(user.toMap());
      log('User updated successfully: ${user.id}');
      return true;
    } catch (e) {
      log("Error updating user: $e");
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
      log('User deleted successfully: $userId');
      return true;
    } catch (e) {
      log("Error deleting user: $e");
      return false;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      if (userSnapshot.exists) {
        return User.fromMap(userSnapshot.data() as Map<String, dynamic>);
      }
      log('User not found: $userId');
      return null;
    } catch (e) {
      log("Error getting user: $e");
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    try {
      QuerySnapshot userSnapshot = await usersCollection.get();
      for (var doc in userSnapshot.docs) {
        users.add(User.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${users.length} users');
      return users;
    } catch (e) {
      log("Error getting all users: $e");
      return [];
    }
  }

  // Additional useful method: Get users by role
  Future<List<User>> getUsersByRole(String role) async {
    List<User> users = [];
    try {
      QuerySnapshot snapshot =
          await usersCollection.where('role', isEqualTo: role).get();
      for (var doc in snapshot.docs) {
        users.add(User.fromMap(doc.data() as Map<String, dynamic>));
      }
      log('Fetched ${users.length} users with role: $role');
      return users;
    } catch (e) {
      log("Error getting users by role: $e");
      return [];
    }
  }

  // Additional useful method: Update specific field, e.g., lastLoginAt
  Future<bool> updateLastLogin(String userId, DateTime lastLoginAt) async {
    try {
      await usersCollection.doc(userId).update({
        'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      });
      log('Updated lastLoginAt for user: $userId');
      return true;
    } catch (e) {
      log("Error updating lastLoginAt: $e");
      return false;
    }
  }
}
