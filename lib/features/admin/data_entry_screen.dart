// Path: lib/features/admin/data_entry_screen.dart
// Note: This is a simple UI screen for pushing the provided data to Firebase. You can add it to your app's routes or main.
// For MVP, data is hardcoded based on the provided JSON. You can edit the _conceptsData list to change info.
// Click the button to push all concepts to Firebase using the repository.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart'; // For Question

class DataEntryScreen extends ConsumerWidget {
  DataEntryScreen({super.key});

  // Hardcoded data based on the provided JSON. Edit here to change info.
  // For Urdu, add as needed (e.g., nameUrdu: 'Translated Name').
  // Defaults: difficulty 'easy', estimatedTimeMinutes 30, order from index.
  final List<Concept> _conceptsData = [
    Concept(
      id: 'G6_CoreDefinition',
      name: 'What is a Set?',
      grade: 6,
      topic: 'Sets',
      order: 1,
      prerequisites: [],
      content: {
        'introduction':
            'In your daily life, you often group similar things together. For example, you might organize your books on a shelf. In mathematics, we have a special name for a collection that follows three very strict and clear rules. We call it a set.',
        'definition':
            'A set is a collection of objects that has three key properties: 1. Well-Defined: The rule for membership is perfectly clear. 2. Distinct: Each object in the set is unique. 3. Unordered: The order in which the objects are listed does not matter.',
        'examples': [
          {
            'rule': 'Well-Defined',
            'example_is_set': 'The set of fruits in a basket.',
            'example_is_not_set':
                'The collection of tasty fruits because \'tasty\' is an opinion.',
          },
          {
            'rule': 'Distinct',
            'example':
                'The set of letters in the word \'SCHOOL\' is {S, C, H, O, L}.',
          },
          {
            'rule': 'Unordered',
            'example':
                'The set {1, 2, 3} is exactly the same set as {3, 1, 2}.',
          },
        ],
      },
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
      practiceQuizzes: [
        Question(
          id: 'G6_Q_WellDefined',
          text: 'Which of the following is NOT a well-defined set?',
          type: 'multiple_choice',
          options: [
            'The set of all provinces in Pakistan.',
            'The set of all difficult math problems.',
            'The set of all whole numbers less than 10.',
          ],
          correctAnswer: 'The set of all difficult math problems.',
          explanation:
              'Correct! \'Difficult\' is an opinion and is not a well-defined rule.',
          points: 1,
        ),
      ],
    ),
    Concept(
      id: 'G6_Notation',
      name: 'How to Write and Describe Sets',
      grade: 6,
      topic: 'Sets',
      order: 2,
      prerequisites: ['G6_CoreDefinition'],
      content: {
        'introduction': 'There are three common ways to describe a set.',
        'forms': [
          {
            'name': 'Tabular Form (Roster Form)',
            'description':
                'Listing every element inside curly braces { }. Example: V = {a, e, i, o, u}.',
          },
          {
            'name': 'Descriptive Form',
            'description':
                'Using words to describe the set. Example: A = The set of the first five positive whole numbers.',
          },
          {
            'name': 'Set-Builder Form',
            'description':
                'Using a rule to define membership. Example: A = {x | x is a positive whole number and x ≤ 5}.',
          },
        ],
        'membership_symbols':
            'We use ∈ to mean \'is an element of\' and ∉ to mean \'is not an element of\'.',
      },
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
      practiceQuizzes: [
        Question(
          id: 'G6_Q_Translate',
          text:
              'Write the set E = {Set of natural numbers between 6 and 11} in Tabular Form.',
          type: 'fill_in_the_blank',
          correctAnswer: '{7, 8, 9, 10}',
          explanation:
              'Correct! Natural numbers are counting numbers, and \'between\' does not include the endpoints.',
          points: 1,
        ),
      ],
    ),
    // Add the remaining concepts similarly...
    Concept(
      id: 'G6_Classification',
      name: 'Types and Classifications of Sets',
      grade: 6,
      topic: 'Sets',
      order: 3,
      prerequisites: ['G6_Notation'],
      content: {
        'cardinality':
            'The number of distinct elements in a set is called its cardinal number, written as n(A). Example: If A = {1, 7, 9}, then n(A) = 3.',
        'types_by_size': [
          {
            'name': 'Finite/Infinite Set',
            'description':
                'A set is finite if its elements can be counted; otherwise, it is infinite.',
          },
          {
            'name': 'Empty Set (∅)',
            'description': 'A set with zero elements. n(A) = 0.',
          },
          {
            'name': 'Singleton Set',
            'description': 'A set with exactly one element. n(A) = 1.',
          },
        ],
        'comparison': [
          {
            'name': 'Equal Sets (=)',
            'description':
                'Two sets are equal if they have the exact same elements.',
          },
          {
            'name': 'Equivalent Sets (↔)',
            'description':
                'Two sets are equivalent if they have the same number of elements.',
          },
        ],
      },
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
      practiceQuizzes: [
        Question(
          id: 'G6_Q_Equivalent',
          text: 'The sets C = {1, 2, 3} and D = {a, b, c} are...',
          type: 'multiple_choice',
          options: [
            'Equal but not equivalent.',
            'Equivalent but not equal.',
            'Both equal and equivalent.',
          ],
          correctAnswer: 'Equivalent but not equal.',
          explanation:
              'Correct! They have the same number of elements (3) but not the same elements.',
          points: 1,
        ),
      ],
    ),
    Concept(
      id: 'G6_Subsets',
      name: 'Subsets and the Universal Set',
      grade: 6,
      topic: 'Sets',
      order: 4,
      prerequisites: ['G6_CoreDefinition'],
      content: {
        'universal_set':
            'The Universal Set (U) is the big \'context\' that contains all possible elements for a specific problem.',
        'subset_superset':
            'A set \'A\' is a subset (⊆) of set \'B\' if every element of A is also found in B. This makes \'B\' the superset (⊇).',
        'proper_improper':
            'A proper subset (⊂) is truly smaller than the superset. An improper subset is identical to the superset.',
      },
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
      practiceQuizzes: [],
    ),
    Concept(
      id: 'G6_VennDiagrams',
      name: 'Introduction to Venn Diagrams',
      grade: 6,
      topic: 'Sets',
      order: 5,
      prerequisites: ['G6_Subsets'],
      content: {
        'introduction':
            'A Venn Diagram is a drawing that shows the relationship between sets. The Universal set is a rectangle, and the sets are circles inside it.',
        'examples': [
          {
            'type': 'Disjoint Sets',
            'description':
                'To show two sets with no common elements, we draw two separate, non-overlapping circles.',
          },
          {
            'type': 'Subset',
            'description':
                'To show that B is a subset of A, we draw the circle for B completely inside the circle for A.',
          },
        ],
      },
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
      practiceQuizzes: [],
    ),
    Concept(
      id: 'G7_SetOperations',
      name: 'The Four Basic Operations on Sets',
      grade: 7,
      topic: 'Sets',
      order: 6,
      prerequisites: ['G6_CoreDefinition', 'G6_VennDiagrams'],
      content: {
        'introduction':
            'In Grade 6, you mastered the fundamentals of sets. Now, we will use that knowledge to perform operations to combine and compare sets.',
        'operations': [
          {
            'name': 'Intersection (∩)',
            'description':
                'A new set containing only the elements that are in BOTH sets. If A ∩ B = ∅, the sets are disjoint.',
            'example': 'If A = {3, 6, 9} and B = {2, 6, 8}, then A ∩ B = {6}.',
          },
          {
            'name': 'Union (∪)',
            'description':
                'A new set containing ALL the elements from BOTH sets combined (no repeats).',
            'example':
                'If A = {1, 2, 5} and B = {1, 3, 5}, then A ∪ B = {1, 2, 3, 5}.',
          },
          {
            'name': 'Difference (-)',
            'description':
                'A - B is a new set containing elements that are in set A but NOT in set B.',
            'example':
                'If A = {3, 5, 7} and B = {1, 3, 4}, then A - B = {5, 7}.',
          },
          {
            'name': 'Complement (A\')',
            'description':
                'Everything in the Universal Set (U) that is NOT in set A. It is a special type of difference: A\' = U - A.',
            'example':
                'If U = {1, ..., 5} and A = {1, 2}, then A\' = {3, 4, 5}.',
          },
        ],
      },
      difficulty: 'medium',
      estimatedTimeMinutes: 45,
      practiceQuizzes: [
        Question(
          id: 'G7_Q_Ops',
          text: 'Let A = {a, b, c, d, e} and F = {a, e, i, o, u}. Find A ∩ F.',
          type: 'short_answer',
          correctAnswer: '{a, e}',
          explanation:
              'Correct! \'a\' and \'e\' are the only elements found in both sets.',
          points: 1,
        ),
      ],
    ),
    Concept(
      id: 'G7_DeMorgansIntro',
      name: 'Introduction to De Morgan\'s Laws',
      grade: 7,
      topic: 'Sets',
      order: 7,
      prerequisites: ['G7_SetOperations'],
      content: {
        'introduction':
            'Sets follow logical rules. The most famous are De Morgan\'s Laws, which describe the \'opposite\' of unions and intersections.',
        'laws': [
          {
            'name': 'De Morgan\'s Law of Union',
            'formula': '(A ∪ B)\' = A\' ∩ B\'',
            'in_words':
                'Everything that is NOT in (A or B) is the same as Everything that is (NOT in A) AND (NOT in B).',
          },
          {
            'name': 'De Morgan\'s Law of Intersection',
            'formula': '(A ∩ B)\' = A\' ∪ B\'',
            'in_words':
                'Everything that is NOT in (A and B) is the same as Everything that is (NOT in A) OR (NOT in B).',
          },
        ],
      },
      difficulty: 'medium',
      estimatedTimeMinutes: 45,
      practiceQuizzes: [],
    ),
    Concept(
      id: 'G8_PowerSet',
      name: 'The Power Set',
      grade: 8,
      topic: 'Sets',
      order: 8,
      prerequisites: ['G6_Subsets'],
      content: {
        'introduction':
            'The Power Set of a set A, written P(A), is the set of all possible subsets of A.',
        'example':
            'To find the Power Set of A = {1, 2}: First, list all subsets: ∅, {1}, {2}, {1, 2}. Then, P(A) = { ∅, {1}, {2}, {1, 2} }.',
        'formula':
            'If a set A has \'n\' elements, then its Power Set, P(A), will have 2ⁿ elements.',
      },
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
      practiceQuizzes: [
        Question(
          id: 'G8_Q_PowerSet',
          text: 'Let A = {a, b, c}. Write out the full Power Set, P(A).',
          type: 'short_answer',
          correctAnswer: '{∅, {a}, {b}, {c}, {a,b}, {a,c}, {b,c}, {a,b,c}}',
          explanation: 'Correct! A set with 3 elements has 2³ = 8 subsets.',
          points: 1,
        ),
      ],
    ),
    Concept(
      id: 'G8_SetProperties',
      name: 'Properties of Set Operations',
      grade: 8,
      topic: 'Sets',
      order: 9,
      prerequisites: ['G7_SetOperations'],
      content: {
        'introduction':
            'Set operations follow logical rules, just like regular arithmetic.',
        'properties': [
          {
            'name': 'Commutative Property',
            'description':
                'Order doesn\'t matter. A ∪ B = B ∪ A and A ∩ B = B ∩ A.',
          },
          {
            'name': 'Associative Property',
            'description':
                'Grouping doesn\'t matter. (A ∪ B) ∪ C = A ∪ (B ∪ C).',
          },
          {
            'name': 'Distributive Property',
            'description':
                'This property connects Union and Intersection. A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C).',
          },
        ],
      },
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
      practiceQuizzes: [],
    ),
    Concept(
      id: 'G8_WordProblems',
      name: 'Applying Set Theory to Real-World Problems',
      grade: 8,
      topic: 'Sets',
      order: 10,
      prerequisites: ['G7_SetOperations', 'G8_SetProperties'],
      content: {
        'introduction':
            'We can use our knowledge of set operations, especially the Principle of Inclusion-Exclusion, to solve practical problems.',
        'formula': 'n(A ∪ B) = n(A) + n(B) - n(A ∩ B)',
        'example':
            'In a class of 50 students, 22 have pencils, 32 have pens, and 8 have both. How many have neither? Solution: n(Pencils ∪ Pens) = 22 + 32 - 8 = 46. The number who have neither is the complement: n(U) - 46 = 50 - 46 = 4.',
      },
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
      practiceQuizzes: [],
    ),
  ];

  Future<void> _pushData(WidgetRef ref) async {
    final repo = ref.read(conceptsRepositoryProvider);
    for (var concept in _conceptsData) {
      final success = await repo.addConcept(concept);
      if (!success) {
        // Handle error, e.g., show snackbar
        log('Failed to add concept: ${concept.id}');
      }
    }
    // Show success message
    log('All concepts pushed to Firebase');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Entry - Push Sets Concepts')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pushData(ref),
          child: const Text('Push Data to Firebase'),
        ),
      ),
    );
  }
}
