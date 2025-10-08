// Path: lib/features/admin/data_entry_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart';
import 'package:taleem_ai/core/domain/entities/content.dart';

class DataEntryScreen extends ConsumerWidget {
  DataEntryScreen({super.key});

  final List<Concept> _conceptsData = [
    Concept(
      conceptId: 'G6_CoreDefinition',
      title: 'What is a Set?',
      gradeLevel: 6,
      topic: 'Sets',
      order: 1,
      prerequisites: [],
      content: Content(
        introduction:
            'In your daily life, you often group similar things together. For example, you might organize your books on a shelf. In mathematics, we have a special name for a collection that follows three very strict and clear rules. We call it a set.',
        definition:
            'A set is a collection of objects that has three key properties: 1. Well-Defined: The rule for membership is perfectly clear. 2. Distinct: Each object in the set is unique. 3. Unordered: The order in which the objects are listed does not matter.',
        examples: [
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
        practiceQuiz: [
          {
            'question_id': 'G6_Q_WellDefined',
            'type': 'multiple_choice',
            'question_text':
                'Which of the following is NOT a well-defined set?',
            'options': [
              'The set of all provinces in Pakistan.',
              'The set of all difficult math problems.',
              'The set of all whole numbers less than 10.',
            ],
            'correct_answer': 'The set of all difficult math problems.',
            'feedback':
                'Correct! \'Difficult\' is an opinion and is not a well-defined rule.',
          },
        ],
      ),
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Notation',
      title: 'How to Write and Describe Sets',
      gradeLevel: 6,
      topic: 'Sets',
      order: 2,
      prerequisites: ['G6_CoreDefinition'],
      content: Content(
        introduction: 'There are three common ways to describe a set.',
        forms: [
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
        membershipSymbols:
            'We use ∈ to mean \'is an element of\' and ∉ to mean \'is not an element of\'.',
        practiceQuiz: [
          {
            'question_id': 'G6_Q_Translate',
            'type': 'fill_in_the_blank',
            'question_text':
                'Write the set E = {Set of natural numbers between 6 and 11} in Tabular Form.',
            'correct_answer': '{7, 8, 9, 10}',
            'feedback':
                'Correct! Natural numbers are counting numbers, and \'between\' does not include the endpoints.',
          },
        ],
      ),
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Classification',
      title: 'Types and Classifications of Sets',
      gradeLevel: 6,
      topic: 'Sets',
      order: 3,
      prerequisites: ['G6_Notation'],
      content: Content(
        cardinality:
            'The number of distinct elements in a set is called its cardinal number, written as n(A). Example: If A = {1, 7, 9}, then n(A) = 3.',
        typesBySize: [
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
        comparison: [
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
        practiceQuiz: [
          {
            'question_id': 'G6_Q_Equivalent',
            'type': 'multiple_choice',
            'question_text': 'The sets C = {1, 2, 3} and D = {a, b, c} are...',
            'options': [
              'Equal but not equivalent.',
              'Equivalent but not equal.',
              'Both equal and equivalent.',
            ],
            'correct_answer': 'Equivalent but not equal.',
            'feedback':
                'Correct! They have the same number of elements (3) but not the same elements.',
          },
        ],
      ),
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Subsets',
      title: 'Subsets and the Universal Set',
      gradeLevel: 6,
      topic: 'Sets',
      order: 4,
      prerequisites: ['G6_CoreDefinition'],
      content: Content(
        universalSet:
            'The Universal Set (U) is the big \'context\' that contains all possible elements for a specific problem.',
        subsetSuperset:
            'A set \'A\' is a subset (⊆) of set \'B\' if every element of A is also found in B. This makes \'B\' the superset (⊇).',
        properImproper:
            'A proper subset (⊂) is truly smaller than the superset. An improper subset is identical to the superset.',
      ),
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_VennDiagrams',
      title: 'Introduction to Venn Diagrams',
      gradeLevel: 6,
      topic: 'Sets',
      order: 5,
      prerequisites: ['G6_Subsets'],
      content: Content(
        introduction:
            'A Venn Diagram is a drawing that shows the relationship between sets. The Universal set is a rectangle, and the sets are circles inside it.',
        examples: [
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
      ),
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G7_SetOperations',
      title: 'The Four Basic Operations on Sets',
      gradeLevel: 7,
      topic: 'Sets',
      order: 6,
      prerequisites: ['G6_CoreDefinition', 'G6_VennDiagrams'],
      content: Content(
        introduction:
            'In Grade 6, you mastered the fundamentals of sets. Now, we will use that knowledge to perform operations to combine and compare sets.',
        operations: [
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
        practiceQuiz: [
          {
            'question_id': 'G7_Q_Ops',
            'type': 'short_answer',
            'question_text':
                'Let A = {a, b, c, d, e} and F = {a, e, i, o, u}. Find A ∩ F.',
            'correct_answer': '{a, e}',
            'feedback':
                'Correct! \'a\' and \'e\' are the only elements found in both sets.',
          },
        ],
      ),
      difficulty: 'medium',
      estimatedTimeMinutes: 45,
    ),
    Concept(
      conceptId: 'G7_DeMorgansIntro',
      title: 'Introduction to De Morgan\'s Laws',
      gradeLevel: 7,
      topic: 'Sets',
      order: 7,
      prerequisites: ['G7_SetOperations'],
      content: Content(
        introduction:
            'Sets follow logical rules. The most famous are De Morgan\'s Laws, which describe the \'opposite\' of unions and intersections.',
        laws: [
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
      ),
      difficulty: 'medium',
      estimatedTimeMinutes: 45,
    ),
    Concept(
      conceptId: 'G8_PowerSet',
      title: 'The Power Set',
      gradeLevel: 8,
      topic: 'Sets',
      order: 8,
      prerequisites: ['G6_Subsets'],
      content: Content(
        introduction:
            'The Power Set of a set A, written P(A), is the set of all possible subsets of A.',
        example:
            'To find the Power Set of A = {1, 2}: First, list all subsets: ∅, {1}, {2}, {1, 2}. Then, P(A) = { ∅, {1}, {2}, {1, 2} }.',
        formula:
            'If a set A has \'n\' elements, then its Power Set, P(A), will have 2ⁿ elements.',
        practiceQuiz: [
          {
            'question_id': 'G8_Q_PowerSet',
            'type': 'short_answer',
            'question_text':
                'Let A = {a, b, c}. Write out the full Power Set, P(A).',
            'correct_answer':
                '{∅, {a}, {b}, {c}, {a,b}, {a,c}, {b,c}, {a,b,c}}',
            'feedback': 'Correct! A set with 3 elements has 2³ = 8 subsets.',
          },
        ],
      ),
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
    ),
    Concept(
      conceptId: 'G8_SetProperties',
      title: 'Properties of Set Operations',
      gradeLevel: 8,
      topic: 'Sets',
      order: 9,
      prerequisites: ['G7_SetOperations'],
      content: Content(
        introduction:
            'Set operations follow logical rules, just like regular arithmetic.',
        properties: [
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
      ),
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
    ),
    Concept(
      conceptId: 'G8_WordProblems',
      title: 'Applying Set Theory to Real-World Problems',
      gradeLevel: 8,
      topic: 'Sets',
      order: 10,
      prerequisites: ['G7_SetOperations', 'G8_SetProperties'],
      content: Content(
        introduction:
            'We can use our knowledge of set operations, especially the Principle of Inclusion-Exclusion, to solve practical problems.',
        formula: 'n(A ∪ B) = n(A) + n(B) - n(A ∩ B)',
        example:
            'In a class of 50 students, 22 have pencils, 32 have pens, and 8 have both. How many have neither? Solution: n(Pencils ∪ Pens) = 22 + 32 - 8 = 46. The number who have neither is the complement: n(U) - 46 = 50 - 46 = 4.',
      ),
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
    ),
  ];

  Future<void> _pushData(WidgetRef ref) async {
    final repo = ref.read(conceptsRepositoryProvider);
    for (var concept in _conceptsData) {
      try {
        final success = await repo.addConcept(concept);
        if (!success) {
          log('Failed to add concept: ${concept.conceptId}');
        }
      } catch (e) {
        log('Error adding concept: $e');
        log('Failed to add concept: ${concept.conceptId}');
      }
    }
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
