// Path: lib/features/admin/data_entry_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/concept.dart';
import 'package:taleem_ai/core/domain/entities/content.dart';
import 'package:taleem_ai/core/domain/entities/localized_content.dart';
import 'package:taleem_ai/core/domain/entities/quiz.dart';
import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';

class DataEntryScreen extends ConsumerWidget {
  DataEntryScreen({super.key});

  // This is the converted data ready to be used in your Flutter app
  final List<Concept> conceptsData = [
    // Concept 1: Core Definition
    Concept(
      conceptId: "G6_Sets_CoreDefinition",
      gradeLevel: 6,
      sequenceOrder: 1,
      prerequisites: [],
      teacherRemediationTip: [],
      definesGlossaryTerms: ["Set"],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "What is a Set?",
          content: Content.fromJson({
            'introduction':
                "In your daily life, you often group similar things together, like organizing books on a shelf. In mathematics, a collection that follows three very strict and clear rules is called a set.",
            'definition':
                "A set is a collection of objects that has three key properties: 1. Well-Defined: The rule for membership is perfectly clear. 2. Distinct: Each object in the set is unique. 3. Unordered: The order in which the objects are listed does not matter.",
            'examples': [
              {
                'rule': "Well-Defined",
                'example_is_set': "The set of fruits in a basket.",
                'example_is_not_set':
                    "The collection of tasty fruits (because 'tasty' is an opinion).",
              },
              {
                'rule': "Distinct",
                'example':
                    "The set of letters in the word 'SCHOOL' is {S, C, H, O, L}.",
              },
              {
                'rule': "Unordered",
                'example':
                    "The set {1, 2, 3} is the same as the set {3, 1, 2}.",
              },
            ],
          }),
          keySentences: [
            "A set is a collection of objects that has three key properties: Well-Defined, Distinct, and Unordered.",
            "Well-Defined means the rule for membership is perfectly clear, with no opinions.",
          ],
          practiceQuiz: [
            PracticeQuiz(
              questionId: "G6_Q_WellDefined",
              type: "multiple_choice",
              questionText: "Which of the following is NOT a well-defined set?",
              options: [
                "The set of all provinces in Pakistan.",
                "The set of all difficult math problems.",
                "The set of all whole numbers less than 10.",
              ],
              correctAnswer: "The set of all difficult math problems.",
              feedback:
                  "Correct! 'Difficult' is an opinion and is not a well-defined rule.",
            ),
          ],
        ),
        'ur': LocalizedContent(
          title: "سیٹ کیا ہے؟",
          content: Content.fromJson({
            'introduction':
                "آپ کی روزمرہ کی زندگی میں، آپ اکثر اسی طرح کی چیزوں کو ایک ساتھ جمع کرتے ہیں، جیسے شیلف پر کتابوں کو منظم کرنا۔ ریاضی میں، ایک مجموعہ جو تین بہت سخت اور واضح قواعد پر عمل کرتا ہے اسے سیٹ کہا جاتا ہے.",
            'definition':
                "ایک سیٹ اشیاء کا ایک مجموعہ ہے جس میں تین اہم خصوصیات ہیں: ۱۔ اچھی طرح سے بیان کیا گیا: رکنیت کا قاعدہ بالکل واضح ہے۔ ۲۔ مختلف: سیٹ میں ہر چیز منفرد ہے۔ ۳۔ بے ترتیب: جس ترتیب میں اشیاء درج ہیں اس سے کوئی فرق نہیں پڑتا۔",
            'examples': [
              {
                'rule': "Well-Defined",
                'example_is_set': "ایک ٹوکری میں پھلوں کا ایک سیٹ.",
                'example_is_not_set':
                    "ذائقہ دار پھلوں کا مجموعہ (کیونکہ 'ذائقہ دار' ایک رائے ہے) ۔",
              },
              {
                'rule': "مختلف",
                'example': "'SHOOL' لفظ میں حروف کا مجموعہ {S, C, H, O, L}.",
              },
              {
                'rule': "بے ترتیب",
                'example':
                    "{1, 2, 3} کا مجموعہ {3, 1, 2} کے مجموعہ کے برابر ہے۔",
              },
            ],
          }),
          keySentences: [
            "ایک سیٹ اشیاء کا ایک مجموعہ ہے جس میں تین اہم خصوصیات ہیں: اچھی طرح سے بیان کردہ، ممتاز، اور غیر منظم.",
            "Well-Defined کا مطلب ہے کہ رکنیت کے لئے قاعدہ بالکل واضح ہے، کوئی رائے کے بغیر.",
          ],
          practiceQuiz: [
            PracticeQuiz(
              questionId: "G6_Q_WellDefined",
              type: "multiple_choice",
              questionText:
                  "مندرجہ ذیل میں سے کون سا ایک اچھی طرح سے بیان کردہ سیٹ نہیں ہے؟",
              options: [
                "پاکستان کے تمام صوبوں کا مجموعہ۔",
                "تمام مشکل ریاضی کے مسائل کا مجموعہ.",
                "10 سے کم تمام عددوں کا مجموعہ۔",
              ],
              correctAnswer: "The set of all difficult math problems.",
              feedback:
                  "درست! 'مشکل' ایک رائے ہے اور یہ کوئی واضح قاعدہ نہیں ہے۔",
            ),
          ],
        ),
      },
    ),

    // Concept 2: Notation
    Concept(
      conceptId: "G6_Sets_Notation",
      gradeLevel: 6,
      sequenceOrder: 2,
      prerequisites: ["G6_Sets_CoreDefinition"],
      teacherRemediationTip: [],
      definesGlossaryTerms: [
        "Tabular Form",
        "Descriptive Form",
        "Set-Builder Form",
        "Element",
      ],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "How to Write and Describe Sets",
          content: Content.fromJson({
            'introduction':
                "There are three common ways to describe a set. We also use special symbols to show if an object is an element of a set.",
            'forms': [
              {
                'name': "Tabular Form (Roster Form)",
                'description':
                    "Listing every element inside curly braces { }. Example: V = {a, e, i, o, u}.",
              },
              {
                'name': "Descriptive Form",
                'description':
                    "Using words to describe the set. Example: A = The set of the first five positive whole numbers.",
              },
              {
                'name': "Set-Builder Form",
                'description':
                    "Using a rule to define membership. Example: A = {x | x is a positive whole number and x ≤ 5}.",
              },
            ],
            'membership_symbols':
                "We use ∈ to mean 'is an element of' and ∉ to mean 'is not an element of'.",
          }),
          keySentences: [
            "A set can be described in Tabular, Descriptive, or Set-Builder form.",
            "The symbol ∈ means 'is an element of'.",
          ],
          practiceQuiz: [
            PracticeQuiz(
              questionId: "G6_Q_Translate",
              type: "fill_in_the_blank",
              questionText:
                  "Write the set E = {Set of natural numbers between 6 and 11} in Tabular Form.",
              correctAnswer: "{7, 8, 9, 10}",
              feedback: "Correct! 'Between' does not include the endpoints.",
            ),
          ],
        ),
        'ur': LocalizedContent(
          title: "سیٹ لکھنے اور بیان کرنے کا طریقہ",
          content: Content.fromJson({
            'introduction':
                "ایک سیٹ کو بیان کرنے کے تین عام طریقے ہیں۔ ہم یہ ظاہر کرنے کے لئے بھی خصوصی علامتوں کا استعمال کرتے ہیں کہ آیا کوئی چیز سیٹ کا عنصر ہے۔",
            'forms': [
              {
                'name': "Tabular Form (Roster Form)",
                'description':
                    "curly braces { } کے اندر ہر عنصر کو درج کرنا۔ مثال: V = {a, e, i, o, u}.",
              },
              {
                'name': "Descriptive Form",
                'description':
                    "سیٹ کی وضاحت کرنے کے لیے الفاظ کا استعمال۔ مثال: A = پہلے پانچ مثبت عددوں کا سیٹ۔",
              },
              {
                'name': "Set-Builder Form",
                'description':
                    "رکنیت کی وضاحت کرنے کے لئے ایک قاعدہ کا استعمال کرتے ہوئے. مثال: A = {x، x ایک مثبت عدد ہے اور x ≤ 5}.",
              },
            ],
            'membership_symbols':
                "ہم ∈ کا استعمال کرتے ہیں جس کا مطلب ہے 'is an element of' اور  کا مطلب ہے 'is not an element of'.",
          }),
          keySentences: [
            "ایک سیٹ کو Tabular، Descriptive، یا Set-Builder شکل میں بیان کیا جا سکتا ہے۔",
            "علامت ∈ کا مطلب ہے 'کی ایک عنصر ہے'۔",
          ],
          practiceQuiz: [
            PracticeQuiz(
              questionId: "G6_Q_Translate",
              type: "fill_in_the_blank",
              questionText:
                  "ٹیبل فارم میں سیٹ E = {6 اور 11 کے درمیان قدرتی نمبروں کا سیٹ} لکھیں۔",
              correctAnswer: "{7, 8, 9, 10}",
              feedback: "درست! 'بَیْن' میں اختتام پوائنٹس شامل نہیں ہیں۔",
            ),
          ],
        ),
      },
    ),

    // Concept 3: Classification
    Concept(
      conceptId: "G6_Sets_Classification",
      gradeLevel: 6,
      sequenceOrder: 3,
      prerequisites: ["G6_Sets_Notation"],
      teacherRemediationTip: [],
      definesGlossaryTerms: [
        "Cardinality",
        "Finite Set",
        "Infinite Set",
        "Empty Set",
        "Singleton Set",
        "Equal Sets",
        "Equivalent Sets",
      ],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "Types and Classifications of Sets",
          content: Content.fromJson({
            'cardinality':
                "The number of distinct elements in a set is called its cardinal number, written as n(A). Example: If A = {1, 7, 9}, then n(A) = 3.",
            'types_by_size': [
              {
                'name': "Finite/Infinite Set",
                'description':
                    "A set is finite if its elements can be counted; otherwise, it is infinite.",
              },
              {
                'name': "Empty Set (∅)",
                'description': "A set with zero elements.",
              },
              {
                'name': "Singleton Set",
                'description': "A set with exactly one element.",
              },
            ],
            'comparison': [
              {
                'name': "Equal Sets (=)",
                'description':
                    "Two sets are equal if they have the exact same elements.",
              },
              {
                'name': "Equivalent Sets (↔)",
                'description':
                    "Two sets are equivalent if they have the same number of elements.",
              },
            ],
          }),
          keySentences: [
            "The number of distinct elements in a set is called its cardinal number, n(A).",
            "Equal sets have the exact same elements, while equivalent sets have the same number of elements.",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "سیٹوں کی اقسام اور درجہ بندی",
          content: Content.fromJson({
            'cardinality':
                "ایک سیٹ میں الگ الگ عناصر کی تعداد کو اس کا کارڈینل نمبر کہا جاتا ہے ، جسے n(A کے طور پر لکھا جاتا ہے۔ مثال: اگر A = {1, 7, 9} ، تو n(A) = 3۔",
            'types_by_size': [
              {
                'name': "Finite/Infinite Set",
                'description':
                    "ایک سیٹ محدود ہے اگر اس کے عناصر کو شمار کیا جا سکے؛ ورنہ، یہ لامحدود ہے۔",
              },
              {
                'name': "Empty Set (∅)",
                'description': "صفر عناصر والا ایک سیٹ۔",
              },
              {
                'name': "Singleton Set",
                'description': "ایک سیٹ جس میں ایک ہی عنصر ہوتا ہے۔",
              },
            ],
            'comparison': [
              {
                'name': "Equal Sets (=)",
                'description':
                    "دو سیٹ برابر ہیں اگر ان میں بالکل ایک ہی عناصر ہوں.",
              },
              {
                'name': "Equivalent Sets (↔)",
                'description':
                    "دو سیٹ مساوی ہیں اگر ان میں عناصر کی ایک ہی تعداد ہو۔",
              },
            ],
          }),
          keySentences: [
            "ایک سیٹ میں الگ الگ عناصر کی تعداد کو اس کا کارڈینل نمبر کہا جاتا ہے، n(A۔",
            "مساوی سیٹوں میں بالکل وہی عناصر ہوتے ہیں، جبکہ مساوی سیٹوں میں عناصر کی ایک ہی تعداد ہوتی ہے۔",
          ],
          practiceQuiz: [],
        ),
      },
    ),

    // Concept 4: Subsets and Universal
    Concept(
      conceptId: "G6_Sets_SubsetsUniversal",
      gradeLevel: 6,
      sequenceOrder: 4,
      prerequisites: ["G6_Sets_CoreDefinition"],
      teacherRemediationTip: [],
      definesGlossaryTerms: [
        "Universal Set",
        "Subset",
        "Superset",
        "Proper Subset",
        "Improper Subset",
      ],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "Subsets and the Universal Set",
          content: Content.fromJson({
            'universal_set':
                "The Universal Set (U) is the big 'context' that contains all possible elements for a specific problem.",
            'subset_superset':
                "A set 'A' is a subset (⊆) of set 'B' if every element of A is also found in B. This makes 'B' the superset (⊇).",
            'proper_improper':
                "A proper subset (⊂) is truly smaller than the superset. An improper subset is identical to the superset.",
          }),
          keySentences: [
            "A set 'A' is a subset of set 'B' if every element of A is also found in B.",
            "A proper subset is truly smaller than the superset.",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "سب سیٹ اور یونیورسل سیٹ",
          content: Content.fromJson({
            'universal_set':
                "یونیورسل سیٹ (U) بڑا 'مطابق' ہے جس میں کسی مخصوص مسئلے کے لیے تمام ممکنہ عناصر شامل ہیں۔",
            'subset_superset':
                "ایک سیٹ 'A' سیٹ 'B' کا ذیلی سیٹ () ہے اگر A کا ہر عنصر B میں بھی پایا جاتا ہے۔ اس سے 'B' سپر سیٹ () بن جاتا ہے۔",
            'proper_improper':
                "ایک صحیح ذیلی سیٹ () واقعی سپر سیٹ سے چھوٹا ہے۔ ایک غلط ذیلی سیٹ سپر سیٹ کے ساتھ یکساں ہے۔",
          }),
          keySentences: [
            "ایک سیٹ 'A' سیٹ 'B' کا ذیلی سیٹ ہے اگر A کا ہر عنصر B میں بھی پایا جاتا ہے۔",
            "ایک مناسب ذیلی سیٹ واقعی سپر سیٹ سے چھوٹا ہے۔",
          ],
          practiceQuiz: [],
        ),
      },
    ),

    // Concept 5: Venn Intro
    Concept(
      conceptId: "G6_Sets_VennIntro",
      gradeLevel: 6,
      sequenceOrder: 5,
      prerequisites: ["G6_Sets_SubsetsUniversal"],
      teacherRemediationTip: [],
      definesGlossaryTerms: ["Venn Diagram"],
      images: ["G6_Sets_VennOverlap.png"],
      interactiveElements: [
        {
          'element_id': "G6_Sets_ChallengeSubsets",
          'type': "Challenge",
          'title': "Final Challenge: The Number of Subsets",
          'content':
              "Did you know there's a magic formula to find the total number of subsets for any finite set? If a set has 'n' elements, the total number of subsets is 2ⁿ.",
          'quiz': {
            'question_text':
                "Test it! Let C = {red, blue}. It has 2 elements (n=2). The formula says it should have 2² = 4 subsets. Can you list all four?",
            'answer': "{red, blue}, {red}, {blue}, { }",
          },
        },
      ],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "Introduction to Venn Diagrams",
          content: Content.fromJson({
            'introduction':
                "A Venn Diagram is a drawing that shows the relationship between sets. The Universal set is a rectangle, and the sets are circles inside it.",
            'examples': [
              {
                'type': "Disjoint Sets",
                'description':
                    "To show two sets with no common elements, we draw two separate, non-overlapping circles.",
              },
              {
                'type': "Subset",
                'description':
                    "To show that B is a subset of A, we draw the circle for B completely inside the circle for A.",
              },
            ],
          }),
          keySentences: [
            "A Venn Diagram is a drawing that shows the relationship between sets.",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "وین ڈایاگرام کا تعارف",
          content: Content.fromJson({
            'introduction':
                "وین ڈایاگرام ایک ڈرائنگ ہے جو سیٹوں کے مابین تعلقات کو ظاہر کرتا ہے۔ یونیورسل سیٹ ایک مستطیل ہے ، اور سیٹ اس کے اندر دائرے ہیں۔",
            'examples': [
              {
                'type': "Disjoint Sets",
                'description':
                    "دو سیٹوں کو ظاہر کرنے کے لیے جن میں کوئی مشترکہ عنصر نہیں ہے، ہم دو الگ الگ، غیر متباہل حلقے کھینچتے ہیں۔",
              },
              {
                'type': "Subset",
                'description':
                    "ظاہر کرنے کے لئے کہ B A کا ایک ذیلی سیٹ ہے، ہم B کے لئے دائرے کو A کے دائرے کے اندر مکمل طور پر ڈرا.",
              },
            ],
          }),
          keySentences: [
            "وین ڈایاگرام ایک ایسا ڈرائنگ ہے جو سیٹوں کے مابین تعلقات کو ظاہر کرتا ہے۔",
          ],
          practiceQuiz: [],
        ),
      },
    ),

    // Concept 6: Set Operations (Grade 7)
    Concept(
      conceptId: "G7_Sets_SetOperations",
      gradeLevel: 7,
      sequenceOrder: 1,
      prerequisites: ["G6_Sets_CoreDefinition", "G6_Sets_VennIntro"],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: "G6_Sets_CoreDefinition",
          tip:
              "The student may be confused about the basic definition of a set. We recommend reviewing the Grade 6 lesson 'What is a Set?'",
        ),
        TeacherRemediationTip(
          prerequisiteId: "G6_Sets_VennIntro",
          tip:
              "The student may not be comfortable with Venn diagrams. We recommend reviewing the Grade 6 lesson 'Introduction to Venn Diagrams.'",
        ),
      ],
      definesGlossaryTerms: [
        "Intersection",
        "Union",
        "Difference",
        "Complement",
        "Disjoint Sets",
        "Overlapping Sets",
      ],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "The Four Basic Operations on Sets",
          content: Content.fromJson({
            'introduction':
                "In Grade 6, you mastered the fundamentals of sets. Now, we will use that knowledge to perform operations to combine and compare sets.",
            'operations': [
              {
                'name': "Intersection (∩)",
                'description':
                    "A new set containing only the elements that are in BOTH sets. If A ∩ B = ∅, the sets are disjoint.",
                'example':
                    "If A = {3, 6, 9} and B = {2, 6, 8}, then A ∩ B = {6}.",
              },
              {
                'name': "Union (∪)",
                'description':
                    "A new set containing ALL the elements from BOTH sets combined (no repeats).",
                'example':
                    "If A = {1, 2, 5} and B = {1, 3, 5}, then A ∪ B = {1, 2, 3, 5}.",
              },
              {
                'name': "Difference (-)",
                'description':
                    "A - B is a new set containing elements that are in set A but NOT in set B.",
                'example':
                    "If A = {3, 5, 7} and B = {1, 3, 4}, then A - B = {5, 7}.",
              },
              {
                'name': "Complement (A')",
                'description':
                    "Everything in the Universal Set (U) that is NOT in set A. It is a special type of difference: A' = U - A.",
                'example':
                    "If U = {1, ..., 5} and A = {1, 2}, then A' = {3, 4, 5}.",
              },
            ],
          }),
          keySentences: [
            "The intersection (∩) of two sets contains only the elements that are in BOTH sets.",
            "The union (∪) of two sets contains ALL the elements from BOTH sets combined.",
            "The difference A - B contains only the elements that are in set A but are NOT in set B.",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "سیٹ پر چار بنیادی آپریشن",
          content: Content.fromJson({
            'introduction':
                "6ویں گریڈ میں آپ نے سیٹوں کے بنیادی اصولوں پر عبور حاصل کیا ہے۔ اب ہم اس علم کا استعمال سیٹوں کو جوڑنے اور ان کا موازنہ کرنے کے لیے آپریشن کرنے کے لیے کریں گے۔",
            'operations': [
              {
                'name': "Intersection (∩)",
                'description':
                    "ایک نیا سیٹ جس میں صرف وہ عناصر ہوتے ہیں جو دونوں سیٹوں میں ہیں۔ اگر A  B = ، تو سیٹ الگ ہیں۔",
                'example':
                    "اگر A = {3, 6, 9} اور B = {2, 6, 8}، تو A  B = {6}.",
              },
              {
                'name': "Union (∪)",
                'description':
                    "ایک نیا سیٹ جس میں دونوں سیٹوں کے تمام عناصر مل کر شامل ہوں (کوئی تکرار نہیں) ۔",
                'example':
                    "اگر A = {1, 2, 5} اور B = {1, 3, 5}، تو A  B = {1, 2, 3, 5}.",
              },
              {
                'name': "Difference (-)",
                'description':
                    "A - B ایک نیا سیٹ ہوتا ہے جس میں وہ عناصر ہوتے ہیں جو سیٹ A میں ہوتے ہیں لیکن سیٹ B میں نہیں ہوتے۔",
                'example':
                    "اگر A = {3, 5, 7} اور B = {1, 3, 4}، تو A - B = {5, 7}.",
              },
              {
                'name': "Complement (A')",
                'description':
                    "یونیورسل سیٹ (U) میں موجود ہر وہ چیز جو سیٹ A میں نہیں ہے۔ یہ ایک خاص قسم کا فرق ہے: A' = U - A.",
                'example':
                    "اگر U = {1, ..., 5} اور A = {1, 2}، تو A' = {3, 4, 5}.",
              },
            ],
          }),
          keySentences: [
            "دو سیٹوں کا تقاطع () صرف اُن عناصر پر مشتمل ہوتا ہے جو دونوں سیٹوں میں ہوتے ہیں۔",
            "دو سیٹوں کا اتحاد () دونوں سیٹوں کے تمام عناصر کو یکجا کرتا ہے۔",
            "فرق A - B میں صرف وہ عناصر شامل ہیں جو سیٹ A میں ہیں لیکن سیٹ B میں نہیں ہیں۔",
          ],
          practiceQuiz: [],
        ),
      },
    ),

    // Concept 7: De Morgan's Laws
    Concept(
      conceptId: "G7_Sets_DeMorgansIntro",
      gradeLevel: 7,
      sequenceOrder: 2,
      prerequisites: ["G7_Sets_SetOperations"],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: "G7_Sets_SetOperations",
          tip:
              "The student may be struggling with the basic set operations. We recommend reviewing the Grade 7 lesson 'The Four Basic Operations on Sets.'",
        ),
      ],
      definesGlossaryTerms: ["De Morgan's Laws"],
      images: [],
      interactiveElements: [
        {
          'element_id': "G7_Sets_DeMorganChallenge",
          'type': "Challenge",
          'title': "Verify De Morgan's Law!",
          'content':
              "Let U = {1, ..., 10}, A = {2, 4, 6, 8, 10}, and B = {1, 2, 3, 6, 7, 8, 9}. Can you prove that (A ∪ B)' = A' ∩ B'?",
          'steps': [
            "Step 1: Calculate the left side: (A ∪ B)'",
            "Step 2: Calculate the right side: A' ∩ B'",
            "Step 3: Compare your results!",
          ],
        },
      ],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "Introduction to De Morgan's Laws",
          content: Content.fromJson({
            'introduction':
                "Sets follow logical rules. The most famous are De Morgan's Laws, which describe the 'opposite' of unions and intersections.",
            'laws': [
              {
                'name': "De Morgan's Law of Union",
                'formula': "(A ∪ B)' = A' ∩ B'",
                'in_words':
                    "Everything that is NOT in (A or B) is the same as Everything that is (NOT in A) AND (NOT in B).",
              },
              {
                'name': "De Morgan's Law of Intersection",
                'formula': "(A ∩ B)' = A' ∪ B'",
                'in_words':
                    "Everything that is NOT in (A and B) is the same as Everything that is (NOT in A) OR (NOT in B).",
              },
            ],
          }),
          keySentences: [
            "De Morgan's Law of Union states that (A ∪ B)' = A' ∩ B'.",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "ڈی مورگن کے قوانین کا تعارف",
          content: Content.fromJson({
            'introduction':
                "سیٹ منطقی قواعد پر عمل کرتے ہیں۔ سب سے مشہور ڈی مورگن کے قوانین ہیں ، جو یونینوں اور کراسشنز کے 'مقابلہ' کی وضاحت کرتے ہیں۔",
            'laws': [
              {
                'name': "De Morgan's Law of Union",
                'formula': "(A ∪ B)' = A' ∩ B'",
                'in_words':
                    "ہر وہ چیز جو (A یا B) میں نہیں ہے وہی ہے جو (A میں نہیں) اور (B میں نہیں) میں ہے.",
              },
              {
                'name': "De Morgan's Law of Intersection",
                'formula': "(A ∩ B)' = A' ∪ B'",
                'in_words':
                    "ہر وہ چیز جو (A اور B) میں نہیں ہے وہی ہے جو (A میں نہیں) یا (B میں نہیں) میں ہے.",
              },
            ],
          }),
          keySentences: [
            "ڈی مورگن کا قانون یونین کا کہنا ہے کہ (A  B)' = A'  B'.",
          ],
          practiceQuiz: [],
        ),
      },
    ),

    // Concept 8: Power Set (Grade 8)
    Concept(
      conceptId: "G8_Sets_PowerSet",
      gradeLevel: 8,
      sequenceOrder: 1,
      prerequisites: ["G6_Sets_SubsetsUniversal"],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: "G6_Sets_SubsetsUniversal",
          tip:
              "The student may be confused about what a subset is. We recommend reviewing the Grade 6 lesson 'Subsets and the Universal Set.'",
        ),
      ],
      definesGlossaryTerms: ["Power Set"],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "The Power Set",
          content: Content.fromJson({
            'introduction':
                "The Power Set of a set A, written P(A), is the set of all possible subsets of A. The members of a power set are sets themselves.",
            'example':
                "To find the Power Set of A = {1, 2}: First, list all subsets: ∅, {1}, {2}, {1, 2}. Then, P(A) = { ∅, {1}, {2}, {1, 2} }.",
            'formula':
                "If a set A has 'n' elements, then its Power Set, P(A), will have 2ⁿ elements.",
          }),
          keySentences: [
            "The Power Set of a set A is the set of all possible subsets of A.",
            "If a set A has 'n' elements, then its Power Set, P(A), will have 2ⁿ elements.",
          ],
          practiceQuiz: [
            PracticeQuiz(
              questionId: "G8_Q_PowerSet",
              type: "short_answer",
              questionText:
                  "Let A = {a, b, c}. Write out the full Power Set, P(A).",
              correctAnswer: "{∅, {a}, {b}, {c}, {a,b}, {a,c}, {b,c}, {a,b,c}}",
              feedback: "Correct! A set with 3 elements has 2³ = 8 subsets.",
            ),
          ],
        ),
        'ur': LocalizedContent(
          title: "پاور سیٹ",
          content: Content.fromJson({
            'introduction':
                "ایک سیٹ A کا پاور سیٹ، P(A) ، A کے تمام ممکنہ ذیلی سیٹوں کا سیٹ ہے۔ ایک پاور سیٹ کے ارکان خود سیٹ ہیں۔",
            'example':
                "A = {1, 2} کا پاور سیٹ تلاش کرنے کے لئے: سب سے پہلے، تمام ذیلی سیٹوں کی فہرست کریں: ، {1}، {2}، {1, 2}. پھر، P(A) = { ، {1}، {2}، {1, 2}.",
            'formula':
                "If a set A has 'n' elements, then its Power Set, P(A), will have 2ⁿ elements.",
          }),
          keySentences: [
            "ایک سیٹ A کا پاور سیٹ A کے تمام ممکنہ ذیلی سیٹوں کا سیٹ ہے۔",
            "اگر ایک سیٹ A میں 'n' عناصر ہوں تو اس کا پاور سیٹ، P(A، 2n عناصر ہوں گے۔",
          ],
          practiceQuiz: [
            PracticeQuiz(
              questionId: "G8_Q_PowerSet",
              type: "short_answer",
              questionText: "Let A = {a, b, c}. مکمل پاور سیٹ، P(A لکھیں.",
              correctAnswer: "{∅, {a}, {b}, {c}, {a,b}, {a,c}, {b,c}, {a,b,c}}",
              feedback: "درست! 3 عناصر والے سیٹ میں 23 = 8 ذیلی سیٹ ہوتے ہیں۔",
            ),
          ],
        ),
      },
    ),

    // Concept 9: Properties
    Concept(
      conceptId: "G8_Sets_Properties",
      gradeLevel: 8,
      sequenceOrder: 2,
      prerequisites: ["G7_Sets_SetOperations"],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: "G7_Sets_SetOperations",
          tip:
              "The student may need to review the basic set operations. We recommend the Grade 7 lesson 'The Four Basic Operations on Sets.'",
        ),
      ],
      definesGlossaryTerms: [
        "Commutative Property",
        "Associative Property",
        "Distributive Property",
      ],
      images: [],
      interactiveElements: [],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "Properties of Set Operations",
          content: Content.fromJson({
            'introduction':
                "Set operations follow logical rules, just like regular arithmetic.",
            'properties': [
              {
                'name': "Commutative Property",
                'description':
                    "Order doesn't matter. A ∪ B = B ∪ A and A ∩ B = B ∩ A.",
              },
              {
                'name': "Associative Property",
                'description':
                    "Grouping doesn't matter. (A ∪ B) ∪ C = A ∪ (B ∪ C).",
              },
              {
                'name': "Distributive Property",
                'description':
                    "This property connects Union and Intersection. A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C).",
              },
            ],
          }),
          keySentences: [
            "The Commutative Property means the order of sets in a union or intersection does not matter.",
            "The Distributive Property shows how Intersection and Union interact, such as A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C).",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "سیٹ آپریشنز کی خصوصیات",
          content: Content.fromJson({
            'introduction':
                "سیٹ آپریشنز منطقی قواعد پر عمل کرتے ہیں، جیسے باقاعدہ حساب کتاب۔",
            'properties': [
              {
                'name': "Commutative Property",
                'description':
                    "ترتیب سے کوئی فرق نہیں پڑتا۔ A  B = B  A اور A  B = B  A.",
              },
              {
                'name': "Associative Property",
                'description':
                    "گروپ بندی سے کوئی فرق نہیں پڑتا۔ (A  B)  C = A  (B  C)",
              },
              {
                'name': "Distributive Property",
                'description':
                    "یہ پراپرٹی یونین اور انٹرسٹیشن کو جوڑتی ہے۔ A  (B  C) = (A  B)  (A  C)",
              },
            ],
          }),
          keySentences: [
            "Commutative Property کا مطلب ہے کہ کسی یونین یا کراسشن میں سیٹوں کا آرڈر کوئی فرق نہیں پڑتا۔",
            "تقسیم پراپرٹی سے پتہ چلتا ہے کہ کراسشن اور یونین کس طرح تعامل کرتے ہیں، جیسے A  (B  C) = (A  B)  (A  C) ۔",
          ],
          practiceQuiz: [],
        ),
      },
    ),

    // Concept 10: Word Problems
    Concept(
      conceptId: "G8_Sets_WordProblems",
      gradeLevel: 8,
      sequenceOrder: 3,
      prerequisites: ["G7_Sets_SetOperations", "G8_Sets_Properties"],
      teacherRemediationTip: [
        TeacherRemediationTip(
          prerequisiteId: "G7_Sets_SetOperations",
          tip:
              "The student may be struggling to apply the basic set operations to a word problem. We recommend reviewing the Grade 7 lesson on operations.",
        ),
      ],
      definesGlossaryTerms: ["Principle of Inclusion-Exclusion"],
      images: [],
      interactiveElements: [
        {
          'element_id': "G8_Sets_DeMorganVisual",
          'type': "Challenge",
          'title': "Visualizing De Morgan's Law",
          'content':
              "Using a 3-circle Venn Diagram, can you prove that (A ∪ B)' = A' ∩ B' by shading the regions?",
          'hint':
              "On one diagram, shade A ∪ B first, then imagine its complement. On a second diagram, shade A' and B' separately, then find where their shadings overlap. Do the final pictures match?",
        },
      ],
      topic: "sets",
      difficulty: "medium",
      estimatedTimeMinutes: 15,
      localizedContent: {
        'en': LocalizedContent(
          title: "Applying Set Theory to Real-World Problems",
          content: Content.fromJson({
            'introduction':
                "We can use our knowledge of set operations, especially the Principle of Inclusion-Exclusion, to solve practical problems.",
            'formula': "n(A ∪ B) = n(A) + n(B) - n(A ∩ B)",
            'example':
                "In a class of 50 students, 22 have pencils, 32 have pens, and 8 have both. How many have neither? Solution: n(Pencils ∪ Pens) = 22 + 32 - 8 = 46. The number who have neither is the complement: n(U) - 46 = 50 - 46 = 4.",
          }),
          keySentences: [
            "The Principle of Inclusion-Exclusion is a key formula for solving word problems: n(A ∪ B) = n(A) + n(B) - n(A ∩ B).",
          ],
          practiceQuiz: [],
        ),
        'ur': LocalizedContent(
          title: "Applying Set Theory to Real-World Problems",
          content: Content.fromJson({
            'introduction':
                "ہم عملی مسائل کو حل کرنے کے لیے سیٹ آپریشنز کے اپنے علم کا استعمال کر سکتے ہیں، خاص طور پر شمولیت سے خارج ہونے کا اصول۔",
            'formula': "n(A ∪ B) = n(A) + n(B) - n(A ∩ B)",
            'example':
                "50 طالب علموں کے ایک کلاس میں 22 کے پاس قلم ہیں، 32 کے پاس قلم ہیں، اور 8 کے پاس دونوں ہیں۔ کتنے کے پاس دونوں نہیں ہیں؟ حل: n(پینسلز  قلم) = 22 + 32 - 8 = 46. جو تعداد میں دونوں نہیں ہیں وہ ضمیمہ ہے: n(U) - 46 = 50 - 46 = 4.",
          }),
          keySentences: [
            "شمولیت سے خارج ہونے کا اصول الفاظ کے مسائل کے حل کا ایک اہم فارمولہ ہے: n(A  B) = n(A) + n(B) - n(A  B).",
          ],
          practiceQuiz: [],
        ),
      },
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

    for (var concept in conceptsData) {
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
                'Total Concepts: ${conceptsData.length}',
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
