// Path: lib/core/data/repositories/user_repository.dart
import 'package:taleem_ai/core/data/collections/users_collection.dart';
import 'package:taleem_ai/core/domain/entities/user.dart';

class UserRepository {
  final UsersCollection _usersCollection = UsersCollection.instance;

  Future<bool> addUser(User user) async {
    return await _usersCollection.addUser(user);
  }

  Future<bool> updateUser(User user) async {
    return await _usersCollection.updateUser(user);
  }

  Future<bool> deleteUser(String userId) async {
    return await _usersCollection.deleteUser(userId);
  }

  Future<User?> getUser(String userId) async {
    return await _usersCollection.getUser(userId);
  }

  Future<List<User>> getAllUsers() async {
    return await _usersCollection.getAllUsers();
  }

  Future<List<User>> getUsersByRole(String role) async {
    return await _usersCollection.getUsersByRole(role);
  }

  Future<bool> updateLastLogin(String userId, DateTime lastLoginAt) async {
    return await _usersCollection.updateLastLogin(userId, lastLoginAt);
  }
}
