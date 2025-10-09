import 'package:cloud_firestore/cloud_firestore.dart';

class Institution {
  final String id;
  final String name;
  final String code;
  final String type; // "school" | "private" | "homeschool"
  final String? address;
  final String? city;
  final String? province;
  final String ownerId; // Teacher who created it
  final List<String> teacherIds; // ADD: Multiple teachers
  final List<String> studentIds;
  final int totalStudents; // ADD: For quick stats
  final int totalTeachers; // ADD: For quick stats
  final bool isActive; // ADD: Can be disabled
  final DateTime createdAt;
  final DateTime updatedAt;

  Institution({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.address,
    this.city,
    this.province,
    required this.ownerId,
    required this.teacherIds,
    required this.studentIds,
    required this.totalStudents,
    required this.totalTeachers,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Institution.fromMap(Map<String, dynamic> map) {
    return Institution(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      address: map['address'] as String?,
      city: map['city'] as String?,
      province: map['province'] as String?,
      ownerId: map['ownerId'] as String,
      teacherIds: List<String>.from(map['teacherIds'] ?? []),
      studentIds: List<String>.from(map['studentIds'] ?? []),
      totalStudents: map['totalStudents'] as int? ?? 0,
      totalTeachers: map['totalTeachers'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'address': address,
      'city': city,
      'province': province,
      'ownerId': ownerId,
      'teacherIds': teacherIds,
      'studentIds': studentIds,
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
