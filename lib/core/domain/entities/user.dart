import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role; // "student" | "teacher" | "parent"
  final int? gradeLevel; // For students only
  final String? institutionId;
  final String? institutionCode;
  final String? parentId; // For students - link to parent
  final List<String>? childrenIds; // For parents - link to students
  final String? profileImageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.gradeLevel,
    this.institutionId,
    this.institutionCode,
    this.parentId,
    this.childrenIds,
    this.profileImageUrl,
    required this.isActive,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      gradeLevel: map['gradeLevel'] as int?,
      institutionId: map['institutionId'] as String?,
      institutionCode: map['institutionCode'] as String?,
      parentId: map['parentId'] as String?,
      childrenIds:
          map['childrenIds'] != null
              ? List<String>.from(map['childrenIds'])
              : null,
      profileImageUrl: map['profileImageUrl'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'gradeLevel': gradeLevel,
      'institutionId': institutionId,
      'institutionCode': institutionCode,
      'parentId': parentId,
      'childrenIds': childrenIds,
      'profileImageUrl': profileImageUrl,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }
}
