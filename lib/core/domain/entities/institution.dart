// Path: lib/core/domain/entities/institution.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Institution {
  final String id;
  final String name;
  final String code;
  final String type; // "school" | "private" | "homeschool"
  final String? city;
  final String ownerId;
  final List<String> studentIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Institution({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.city,
    required this.ownerId,
    required this.studentIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Institution.fromMap(Map<String, dynamic> map) {
    return Institution(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      city: map['city'] as String?,
      ownerId: map['ownerId'] as String,
      studentIds: List<String>.from(map['studentIds'] ?? []),
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
      'city': city,
      'ownerId': ownerId,
      'studentIds': studentIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
