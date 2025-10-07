// Path: lib/core/domain/entities/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String role; // "student" | "teacher" | "parent"
  final int? grade;
  final String? institutionId;
  final String? institutionCode;
  final String? ownedInstitutionId;
  final String? profilePicture;
  final String language; // "en" | "ur"
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.grade,
    this.institutionId,
    this.institutionCode,
    this.ownedInstitutionId,
    this.profilePicture,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      grade: map['grade'] as int?,
      institutionId: map['institutionId'] as String?,
      institutionCode: map['institutionCode'] as String?,
      ownedInstitutionId: map['ownedInstitutionId'] as String?,
      profilePicture: map['profilePicture'] as String?,
      language: map['language'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'grade': grade,
      'institutionId': institutionId,
      'institutionCode': institutionCode,
      'ownedInstitutionId': ownedInstitutionId,
      'profilePicture': profilePicture,
      'language': language,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }
}
