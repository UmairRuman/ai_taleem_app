import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart'; // Added for robust equality checks

class Institution extends Equatable {
  final String id;
  final String name;
  final String code;
  final String type; // e.g., "school" | "private" | "homeschool"
  final String city; // From screenshot
  final String? address; // Optional, as not in screenshot explicitly
  final String? province; // Optional
  final String ownerId; // ID of the teacher/admin who created this institution
  final List<String> teacherIds;
  final List<String> studentIds;
  final List<String>
  parentIds; // Added: For parent accounts linked to this institution
  final int totalStudents; // Derived for quick access
  final int totalTeachers; // Derived for quick access
  final int totalParents; // Added: Derived for quick access
  final bool isActive; // To enable/disable institutions
  final DateTime createdAt;
  final DateTime updatedAt;

  const Institution({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.city, // Made required as it's in the screenshot
    this.address,
    this.province,
    required this.ownerId,
    this.teacherIds = const [], // Default to empty list
    this.studentIds = const [], // Default to empty list
    this.parentIds = const [], // Default to empty list
    int? totalStudents, // Allow nullable in constructor for auto-derivation
    int? totalTeachers, // Allow nullable in constructor for auto-derivation
    int? totalParents, // Allow nullable in constructor for auto-derivation
    this.isActive = true, // Default to active
    required this.createdAt,
    required this.updatedAt,
  }) : totalStudents = totalStudents ?? studentIds.length,
       totalTeachers = totalTeachers ?? teacherIds.length,
       totalParents = totalParents ?? parentIds.length;

  // Factory constructor for creating an Institution from a Firestore Map
  factory Institution.fromMap(Map<String, dynamic> map) {
    return Institution(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      city: map['city'] as String? ?? 'Unknown', // Handle missing city safely
      address: map['address'] as String?,
      province: map['province'] as String?,
      ownerId: map['ownerId'] as String,
      teacherIds: List<String>.from(map['teacherIds'] ?? []),
      studentIds: List<String>.from(map['studentIds'] ?? []),
      parentIds: List<String>.from(map['parentIds'] ?? []), // Parse parentIds
      totalStudents:
          map['totalStudents'] as int? ??
          (List<String>.from(map['studentIds'] ?? [])).length,
      totalTeachers:
          map['totalTeachers'] as int? ??
          (List<String>.from(map['teacherIds'] ?? [])).length,
      totalParents:
          map['totalParents'] as int? ??
          (List<String>.from(
            map['parentIds'] ?? [],
          )).length, // Parse totalParents
      isActive: map['isActive'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert Institution object to a Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'city': city,
      'address': address,
      'province': province,
      'ownerId': ownerId,
      'teacherIds': teacherIds,
      'studentIds': studentIds,
      'parentIds': parentIds,
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
      'totalParents': totalParents,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // For Equatable
  @override
  List<Object?> get props => [
    id,
    name,
    code,
    type,
    city,
    address,
    province,
    ownerId,
    teacherIds,
    studentIds,
    parentIds,
    totalStudents,
    totalTeachers,
    totalParents,
    isActive,
    createdAt,
    updatedAt,
  ];
}
