import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:taleem_ai/core/domain/entities/institution.dart';
// Adjust path as necessary

class FakeDataGenerator {
  final Faker _faker = Faker();

  // Generates a list of fake user IDs (teachers, students, parents)
  List<String> _generateUserIds(String prefix, int count) {
    return List.generate(
      count,
      (index) => '${prefix}_${_faker.randomGenerator.integer(99999)}',
    );
  }

  // Generates a single fake Institution
  Institution generateFakeInstitution({
    String? id,
    int minStudents = 5,
    int maxStudents = 50,
    int minTeachers = 1,
    int maxTeachers = 10,
    int minParents = 5,
    int maxParents = 70,
  }) {
    final String institutionId =
        id ?? 'inst_${_faker.randomGenerator.integer(1000, min: 1)}';
    final String ownerId =
        'teacher_${_faker.randomGenerator.integer(100, min: 1)}';

    final int numStudents = _faker.randomGenerator.integer(
      maxStudents,
      min: minStudents,
    );
    final int numTeachers = _faker.randomGenerator.integer(
      maxTeachers,
      min: minTeachers,
    );
    final int numParents = _faker.randomGenerator.integer(
      maxParents,
      min: minParents,
    );

    final List<String> studentIds = _generateUserIds('student', numStudents);
    final List<String> teacherIds = _generateUserIds('teacher', numTeachers);
    final List<String> parentIds = _generateUserIds('parent', numParents);

    final DateTime createdAt = DateTime.now();
    final DateTime updatedAt = createdAt.add(
      Duration(days: _faker.randomGenerator.integer(300)),
    );

    return Institution(
      id: institutionId,
      name: '${_faker.company.name()} School',
      code: _faker.randomGenerator.string(6, min: 6).toUpperCase(),
      type: _faker.randomGenerator.element(['school', 'private', 'homeschool']),
      city: _faker.address.city(),
      address: _faker.address.streetAddress(),
      province: _faker.randomGenerator.element([
        'Punjab',
        'Sindh',
        'Khyber Pakhtunkhwa',
        'Balochistan',
      ]),
      ownerId: ownerId,
      teacherIds: teacherIds,
      studentIds: studentIds,
      parentIds: parentIds,
      isActive: _faker.randomGenerator.boolean(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generates a list of fake Institutions
  List<Institution> generateFakeInstitutions(int count) {
    return List.generate(
      count,
      (index) => generateFakeInstitution(id: 'inst_${index + 1}'),
    );
  }

  // --- Firestore Integration (for adding to your dev database) ---
  Future<void> addFakeInstitutionsToFirestore(int count) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();
    final institutions = generateFakeInstitutions(count);

    print(
      'Generating $count fake institutions and preparing for Firestore upload...',
    );

    for (var inst in institutions) {
      final docRef = firestore.collection('institutions').doc(inst.id);
      batch.set(docRef, inst.toMap());
    }

    try {
      await batch.commit();
      print('Successfully added $count fake institutions to Firestore!');
    } catch (e) {
      print('Error adding fake institutions to Firestore: $e');
      rethrow;
    }
  }
}
