// Path: lib/features/admin/data_entry_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart';
import 'package:taleem_ai/core/domain/entities/content.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart';
import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';

class DataEntryScreen extends ConsumerWidget {
  DataEntryScreen({super.key});

  final List<Concept> _conceptsData = [
    // Grade 6 Concepts
    Concept(
      conceptId: 'G6_Sets_CoreDefinition',
      gradeLevel: 6,
      title: 'What is a Set?',
      sequenceOrder: 1,
      prerequisites: [],
      teacherRemediationTip: [],
      definesGlossaryTerms: ['Set'],
      content: Content(
        introduction:
            'In your daily life, you often group similar things together, like organizing books on a shelf. In mathematics, a collection that follows three very strict and clear rules is called a set.',
        definition:
            'A set is a collection of objects that has three key properties: 1. Well-Defined: The rule for membership is perfectly clear. 2. Distinct: Each object in the set is unique. 3. Unordered: The order in which the objects are listed does not matter.',
        examples: [
          {
            'rule': 'Well-Defined',
            'example_is_set': 'The set of fruits in a basket.',
            'example_is_not_set':
                'The collection of tasty fruits (because \'tasty\' is an opinion).',
          },
          {
            'rule': 'Distinct',
            'example':
                'The set of letters in the word \'SCHOOL\' is {S, C, H, O, L}.',
          },
          {
            'rule': 'Unordered',
            'example': 'The set {1, 2, 3} is the same as the set {3, 1, 2}.',
          },
        ],
      ),
      images: [],
      interactiveElements: [],
      keySentences: [
        'A set is a collection of objects that has three key properties: Well-Defined, Distinct, and Unordered.',
        'Well-Defined means the rule for membership is perfectly clear, with no opinions.',
      ],
      practiceQuiz: [
        PracticeQuiz(
          questionId: 'G6_Q_WellDefined',
          type: 'multiple_choice',
          questionText: 'Which of the following is NOT a well-defined set?',
          options: [
            'The set of all provinces in Pakistan.',
            'The set of all difficult math problems.',
            'The set of all whole numbers less than 10.',
          ],
          correctAnswer: 'The set of all difficult math problems.',
          feedback:
              'Correct! \'Difficult\' is an opinion and is not a well-defined rule.',
        ),
      ],
      topic: 'Sets',
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Sets_Notation',
      gradeLevel: 6,
      title: 'How to Write and Describe Sets',
      sequenceOrder: 2,
      prerequisites: ['G6_Sets_CoreDefinition'],
      teacherRemediationTip: [],
      definesGlossaryTerms: [
        'Tabular Form',
        'Descriptive Form',
        'Set-Builder Form',
        'Element',
      ],
      content: Content(
        introduction:
            'There are three common ways to describe a set. We also use special symbols to show if an object is an element of a set.',
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
      ),
      images: [],
      interactiveElements: [],
      keySentences: [
        'A set can be described in Tabular, Descriptive, or Set-Builder form.',
        'The symbol ∈ means \'is an element of\'.',
      ],
      practiceQuiz: [
        PracticeQuiz(
          questionId: 'G6_Q_Translate',
          type: 'fill_in_the_blank',
          questionText:
              'Write the set E = {Set of natural numbers between 6 and 11} in Tabular Form.',
          correctAnswer: '{7, 8, 9, 10}',
          feedback: 'Correct! \'Between\' does not include the endpoints.',
        ),
      ],
      topic: 'Sets',
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Sets_Classification',
      gradeLevel: 6,
      title: 'Types and Classifications of Sets',
      sequenceOrder: 3,
      prerequisites: ['G6_Sets_Notation'],
      teacherRemediationTip: [],
      definesGlossaryTerms: [
        'Cardinality',
        'Finite Set',
        'Infinite Set',
        'Empty Set',
        'Singleton Set',
        'Equal Sets',
        'Equivalent Sets',
      ],
      content: Content(
        cardinality:
            'The number of distinct elements in a set is called its cardinal number, written as n(A). Example: If A = {1, 7, 9}, then n(A) = 3.',
        typesBySize: [
          {
            'name': 'Finite/Infinite Set',
            'description':
                'A set is finite if its elements can be counted; otherwise, it is infinite.',
          },
          {'name': 'Empty Set (∅)', 'description': 'A set with zero elements.'},
          {
            'name': 'Singleton Set',
            'description': 'A set with exactly one element.',
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
      ),
      images: [],
      interactiveElements: [],
      keySentences: [
        'The number of distinct elements in a set is called its cardinal number, n(A).',
        'Equal sets have the exact same elements, while equivalent sets have the same number of elements.',
      ],
      practiceQuiz: [
        PracticeQuiz(
          questionId: 'G6_Q_Equivalent',
          type: 'multiple_choice',
          questionText: 'The sets C = {1, 2, 3} and D = {a, b, c} are...',
          options: [
            'Equal but not equivalent.',
            'Equivalent but not equal.',
            'Both equal and equivalent.',
          ],
          correctAnswer: 'Equivalent but not equal.',
          feedback:
              'Correct! They have the same number of elements (3) but not the same elements.',
        ),
      ],
      topic: 'Sets',
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Sets_SubsetsUniversal',
      gradeLevel: 6,
      title: 'Subsets and the Universal Set',
      sequenceOrder: 4,
      prerequisites: ['G6_Sets_CoreDefinition'],
      teacherRemediationTip: [],
      definesGlossaryTerms: [
        'Universal Set',
        'Subset',
        'Superset',
        'Proper Subset',
        'Improper Subset',
      ],
      content: Content(
        universalSet:
            'The Universal Set (U) is the big \'context\' that contains all possible elements for a specific problem.',
        subsetSuperset:
            'A set \'A\' is a subset (⊆) of set \'B\' if every element of A is also found in B. This makes \'B\' the superset (⊇).',
        properImproper:
            'A proper subset (⊂) is truly smaller than the superset. An improper subset is identical to the superset.',
      ),
      images: [],
      interactiveElements: [],
      keySentences: [
        'A set \'A\' is a subset of set \'B\' if every element of A is also found in B.',
        'A proper subset is truly smaller than the superset.',
      ],
      practiceQuiz: [],
      topic: 'Sets',
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),
    Concept(
      conceptId: 'G6_Sets_VennIntro',
      gradeLevel: 6,
      title: 'Introduction to Venn Diagrams',
      sequenceOrder: 5,
      prerequisites: ['G6_Sets_SubsetsUniversal'],
      teacherRemediationTip: [],
      definesGlossaryTerms: ['Venn Diagram'],
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
      images: [],
      interactiveElements: [],
      keySentences: [
        'A Venn Diagram is a drawing that shows the relationship between sets.',
      ],
      practiceQuiz: [],
      topic: 'Sets',
      difficulty: 'easy',
      estimatedTimeMinutes: 30,
    ),

    // Grade 7 Concepts
    Concept(
      conceptId: 'G7_Sets_SetOperations',
      gradeLevel: 7,
      title: 'The Four Basic Operations on Sets',
      sequenceOrder: 1,
      prerequisites: ['G6_Sets_CoreDefinition', 'G6_Sets_VennIntro'],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: 'G6_Sets_CoreDefinition',
          tip:
              'The student may be confused about the basic definition of a set. We recommend reviewing the Grade 6 lesson \'What is a Set?\'',
        ),
        TeacherRemediationTip(
          prerequisiteId: 'G6_Sets_VennIntro',
          tip:
              'The student may not be comfortable with Venn diagrams. We recommend reviewing the Grade 6 lesson \'Introduction to Venn Diagrams.\'',
        ),
      ],
      definesGlossaryTerms: [
        'Intersection',
        'Union',
        'Difference',
        'Complement',
        'Disjoint Sets',
        'Overlapping Sets',
      ],
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
      ),
      images: [],
      interactiveElements: [],
      keySentences: [
        'The intersection (∩) of two sets contains only the elements that are in BOTH sets.',
        'The union (∪) of two sets contains ALL the elements from BOTH sets combined.',
        'The difference A - B contains only the elements that are in set A but are NOT in set B.',
      ],
      practiceQuiz: [
        PracticeQuiz(
          questionId: 'G7_Q_Ops',
          type: 'short_answer',
          questionText:
              'Let A = {a, b, c, d, e} and F = {a, e, i, o, u}. Find A ∩ F.',
          correctAnswer: '{a, e}',
          feedback:
              'Correct! \'a\' and \'e\' are the only elements found in both sets.',
        ),
      ],
      topic: 'Sets',
      difficulty: 'medium',
      estimatedTimeMinutes: 45,
    ),
    Concept(
      conceptId: 'G7_Sets_DeMorgansIntro',
      gradeLevel: 7,
      title: 'Introduction to De Morgan\'s Laws',
      sequenceOrder: 2,
      prerequisites: ['G7_Sets_SetOperations'],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: 'G7_Sets_SetOperations',
          tip:
              'The student may be struggling with the basic set operations. We recommend reviewing the Grade 7 lesson \'The Four Basic Operations on Sets.\'',
        ),
      ],
      definesGlossaryTerms: ['De Morgan\'s Laws'],
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
      images: [],
      interactiveElements: [],
      keySentences: [
        'De Morgan\'s Law of Union states that (A ∪ B)\' = A\' ∩ B\'.',
      ],
      practiceQuiz: [],
      topic: 'Sets',
      difficulty: 'medium',
      estimatedTimeMinutes: 45,
    ),

    // Grade 8 Concepts
    Concept(
      conceptId: 'G8_Sets_PowerSet',
      gradeLevel: 8,
      title: 'The Power Set',
      sequenceOrder: 1,
      prerequisites: ['G6_Sets_SubsetsUniversal'],
      teacherRemediationTip: [],
      definesGlossaryTerms: ['Power Set'],
      content: Content(
        introduction:
            'The Power Set of a set A, written P(A), is the set of all possible subsets of A.',
        example:
            'To find the Power Set of A = {1, 2}: First, list all subsets: ∅, {1}, {2}, {1, 2}. Then, P(A) = { ∅, {1}, {2}, {1, 2} }.',
        formula:
            'If a set A has \'n\' elements, then its Power Set, P(A), will have 2ⁿ elements.',
      ),
      images: [],

      // 🎯 INTERACTIVE ELEMENTS - ALL THREE TYPES DEMONSTRATED
      interactiveElements: [
        // Type 1: Challenge with Quiz
        {
          'element_id': 'G8_Sets_PowerSet_Challenge1',
          'type': 'Challenge',
          'title': 'Calculate a Power Set',
          'content':
              'Now that you understand the concept, let\'s calculate a power set step by step.',
          'quiz': {
            'question_text':
                'If A = {x, y}, write the complete Power Set P(A) in set notation.',
            'correct_answer': '{∅, {x}, {y}, {x, y}}',
            'feedback':
                'Excellent! Remember: every set has the empty set and itself as subsets.',
          },
          'hint':
              'Start with the empty set ∅, then single elements {x} and {y}, then the complete set.',
        },

        // Type 1: Challenge with Steps
        {
          'element_id': 'G8_Sets_PowerSet_Challenge2',
          'type': 'Challenge',
          'title': 'Multi-Step Power Set Challenge',
          'content':
              'Let\'s find the power set of a 3-element set using a systematic approach.',
          'steps': [
            'Start with A = {1, 2, 3}',
            'List all subsets with 0 elements: ∅',
            'List all subsets with 1 element: {1}, {2}, {3}',
            'List all subsets with 2 elements: {1,2}, {1,3}, {2,3}',
            'List all subsets with 3 elements: {1,2,3}',
            'Combine all: P(A) = {∅, {1}, {2}, {3}, {1,2}, {1,3}, {2,3}, {1,2,3}}',
            'Verify: Count = 8 = 2³ ✓',
          ],
          'hint':
              'Think systematically: start with the smallest subsets and work up to the largest.',
        },

        // Type 2: Thinking Prompt (Meta-Skill Development)
        {
          'element_id': 'G8_Sets_PowerSet_ThinkingPrompt1',
          'type': 'ThinkingPrompt',
          'question':
              'Why do you think the formula for the number of elements in a power set is 2ⁿ? Explain the reasoning behind this exponential relationship.',
        },

        // Type 2: Another Thinking Prompt
        {
          'element_id': 'G8_Sets_PowerSet_ThinkingPrompt2',
          'type': 'ThinkingPrompt',
          'question':
              'Compare the concepts of "subset" and "element of a power set". How are they related? Can you explain why every element of P(A) is a subset of A?',
        },

        // Type 3: AI Tutor Challenge (AI Literacy)
        {
          'element_id': 'G8_Sets_PowerSet_AITutor1',
          'type': 'AITutorChallenge',
          'scenario':
              'You\'re struggling to understand why the power set grows so quickly. Which prompt would help an AI tutor give you the best explanation?',
          'prompts': {
            'poor': 'Why is power set big',
            'good': 'Explain why power sets have 2^n elements',
            'excellent':
                'I\'m learning about Power Sets in Grade 8. I understand that if A has 3 elements, P(A) has 8 elements. But I\'m confused about WHY the formula is 2ⁿ instead of something like n². Can you explain the logic behind this exponential growth with a concrete example?',
          },
          'explanation':
              'The excellent prompt is best because it: (1) Provides context about grade level, (2) Shows what you already know (the specific example), (3) Clearly identifies your confusion (why 2ⁿ and not n²), and (4) Requests a specific type of explanation (logic with concrete example). This helps the AI target exactly what you need to understand.',
        },

        // Type 3: Another AI Tutor Challenge
        {
          'element_id': 'G8_Sets_PowerSet_AITutor2',
          'type': 'AITutorChallenge',
          'scenario':
              'You want to check if your answer to a power set problem is correct. Which prompt demonstrates good AI interaction?',
          'prompts': {
            'poor': 'Is this right',
            'good': 'Check my power set answer',
            'excellent':
                'I calculated P({a, b, c}) = {∅, {a}, {b}, {c}, {a,b}, {a,c}, {b,c}, {a,b,c}}. I got 8 elements which matches 2³ = 8. Can you verify if I listed all subsets correctly and didn\'t miss any?',
          },
          'explanation':
              'The excellent prompt works best because it: (1) Shows your complete work, (2) Demonstrates you understand the formula (2³ = 8), (3) Asks a specific question (did I list all correctly?), and (4) Shows self-checking behavior. This makes it easy for the AI to verify your answer and provide targeted feedback.',
        },
      ],

      keySentences: [
        'The Power Set of a set A is the set of all possible subsets of A.',
        'If a set A has \'n\' elements, then its Power Set will have 2ⁿ elements.',
      ],
      practiceQuiz: [
        PracticeQuiz(
          questionId: 'G8_Q_PowerSet_Basic',
          type: 'short_answer',
          questionText:
              'Let A = {m, n}. Write out the complete Power Set P(A).',
          correctAnswer: '{∅, {m}, {n}, {m, n}}',
          feedback:
              'Perfect! A 2-element set has 2² = 4 subsets in its power set.',
        ),
      ],
      topic: 'Sets',
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
    ),
    Concept(
      conceptId: 'G8_Sets_Properties',
      gradeLevel: 8,
      title: 'Properties of Set Operations',
      sequenceOrder: 2,
      prerequisites: ['G7_Sets_SetOperations'],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: 'G7_Sets_SetOperations',
          tip:
              'The student may need to review the basic set operations. We recommend the Grade 7 lesson \'The Four Basic Operations on Sets.\'',
        ),
      ],
      definesGlossaryTerms: [
        'Commutative Property',
        'Associative Property',
        'Distributive Property',
      ],
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
      images: [],
      interactiveElements: [],
      keySentences: [
        'The Commutative Property means the order of sets in a union or intersection does not matter.',
        'The Distributive Property shows how Intersection and Union interact, such as A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C).',
      ],
      practiceQuiz: [],
      topic: 'Sets',
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
    ),
    Concept(
      conceptId: 'G8_Sets_WordProblems',
      gradeLevel: 8,
      title: 'Applying Set Theory to Real-World Problems',
      sequenceOrder: 3,
      prerequisites: ['G7_Sets_SetOperations', 'G8_Sets_Properties'],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: 'G7_Sets_SetOperations',
          tip:
              'The student may be struggling to apply the basic set operations to a word problem. We recommend reviewing the Grade 7 lesson on operations.',
        ),
      ],
      definesGlossaryTerms: ['Principle of Inclusion-Exclusion'],
      content: Content(
        introduction:
            'We can use our knowledge of set operations, especially the Principle of Inclusion-Exclusion, to solve practical problems.',
        formula: 'n(A ∪ B) = n(A) + n(B) - n(A ∩ B)',
        example:
            'In a class of 50 students, 22 have pencils, 32 have pens, and 8 have both. How many have neither? Solution: n(Pencils ∪ Pens) = 22 + 32 - 8 = 46. The number who have neither is the complement: n(U) - 46 = 50 - 46 = 4.',
      ),
      images: [],
      interactiveElements: [
        {
          "element_id": "G8_Sets_DeMorganVisual",
          "type": "Challenge",
          "title": "Visualizing De Morgan's Law",
          "content":
              "Using a 3-circle Venn Diagram, can you prove that (A ∪ B)' = A' ∩ B' by shading the regions?",
          "hint":
              "On one diagram, shade A ∪ B first, then imagine its complement. On a second diagram, shade A' and B' separately, then find where their shadings overlap. Do the final pictures match?",
        },
      ],
      keySentences: [
        'The Principle of Inclusion-Exclusion is a key formula for solving word problems: n(A ∪ B) = n(A) + n(B) - n(A ∩ B).',
      ],
      practiceQuiz: [],
      topic: 'Sets',
      difficulty: 'hard',
      estimatedTimeMinutes: 60,
    ),
  ];

  Future<void> _deleteOldCollection(WidgetRef ref) async {
    try {
      final repo = ref.read(conceptsRepositoryProvider);
      final allConcepts = await repo.getAllConcepts();

      log('Found ${allConcepts.length} concepts to delete');

      for (var concept in allConcepts) {
        await repo.deleteConcept(concept.conceptId);
        log('Deleted concept: ${concept.conceptId}');
      }

      log('All old concepts deleted successfully');
    } catch (e) {
      log('Error deleting old collection: $e');
    }
  }

  Future<void> _pushData(WidgetRef ref) async {
    final repo = ref.read(conceptsRepositoryProvider);
    int successCount = 0;
    int failCount = 0;

    for (var concept in _conceptsData) {
      try {
        final success = await repo.addConcept(concept);
        if (success) {
          successCount++;
          log('✓ Added concept: ${concept.conceptId}');
        } else {
          failCount++;
          log('✗ Failed to add concept: ${concept.conceptId}');
        }
      } catch (e) {
        failCount++;
        log('✗ Error adding concept ${concept.conceptId}: $e');
      }
    }

    log('===================================');
    log('Push complete: $successCount succeeded, $failCount failed');
    log('===================================');
  }

  Future<void> _deleteAndPush(WidgetRef ref) async {
    log('Starting delete and push process...');
    await _deleteOldCollection(ref);
    log('Old collection deleted. Now pushing new data...');
    await _pushData(ref);
    log('Process complete!');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Entry - Sets Concepts'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storage_rounded, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'Firebase Data Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Concepts: ${_conceptsData.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _deleteAndPush(ref),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Delete Old & Push New Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _pushData(ref),
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('Push New Data Only'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _deleteOldCollection(ref),
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Delete Old Collection Only'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[900]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Check console logs for detailed progress',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
