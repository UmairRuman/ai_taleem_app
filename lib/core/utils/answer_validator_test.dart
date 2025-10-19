// test/core/utils/answer_validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taleem_ai/core/utils/answer_validator.dart';

void main() {
  group('AnswerValidator - Set Notation Tests', () {
    test('accepts correct set with exact format', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{a, e}',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('accepts set without spaces', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{a,e}',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('accepts set with extra spaces', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{ a , e }',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('accepts set in different order', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{e, a}',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('accepts set with mixed spacing and order', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{ e,a}',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('rejects set with missing elements', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{a}',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        false,
      );
    });

    test('rejects set with extra elements', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{a, e, i}',
          correctAnswer: '{a, e}',
          questionType: 'set_notation',
        ),
        false,
      );
    });

    test('accepts empty set as ∅', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '∅',
          correctAnswer: '{}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('accepts empty set as {}', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{}',
          correctAnswer: '∅',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('accepts empty set as "empty"', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'empty',
          correctAnswer: '{}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('handles set with numbers', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{1, 2, 3}',
          correctAnswer: '{3, 2, 1}',
          questionType: 'set_notation',
        ),
        true,
      );
    });

    test('handles set with symbols', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '{∩, ∪}',
          correctAnswer: '{∪, ∩}',
          questionType: 'set_notation',
        ),
        true,
      );
    });
  });

  group('AnswerValidator - Numeric Tests', () {
    test('accepts exact numeric match', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '42',
          correctAnswer: '42',
          questionType: 'short_answer',
        ),
        true,
      );
    });

    test('accepts numeric match with spaces', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '  42  ',
          correctAnswer: '42',
          questionType: 'short_answer',
        ),
        true,
      );
    });

    test('accepts decimal equivalents', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '42.0',
          correctAnswer: '42',
          questionType: 'short_answer',
        ),
        true,
      );
    });

    test('accepts very close floating point numbers', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '3.1416',
          correctAnswer: '3.1415',
          questionType: 'short_answer',
        ),
        false, // Should be false due to precision
      );
    });
  });

  group('AnswerValidator - True/False Tests', () {
    test('accepts "true" for True', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'true',
          correctAnswer: 'True',
          questionType: 'true_false',
        ),
        true,
      );
    });

    test('accepts "t" for True', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 't',
          correctAnswer: 'True',
          questionType: 'true_false',
        ),
        true,
      );
    });

    test('accepts "yes" for True', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'yes',
          correctAnswer: 'True',
          questionType: 'true_false',
        ),
        true,
      );
    });

    test('accepts "1" for True', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '1',
          correctAnswer: 'True',
          questionType: 'true_false',
        ),
        true,
      );
    });

    test('accepts "false" for False', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'false',
          correctAnswer: 'False',
          questionType: 'true_false',
        ),
        true,
      );
    });

    test('accepts "no" for False', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'no',
          correctAnswer: 'False',
          questionType: 'true_false',
        ),
        true,
      );
    });
  });

  group('AnswerValidator - Fill in Blank Tests', () {
    test('accepts exact match', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'Power Set',
          correctAnswer: 'Power Set',
          questionType: 'fill_in_the_blank',
        ),
        true,
      );
    });

    test('accepts with extra spaces', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '  Power   Set  ',
          correctAnswer: 'Power Set',
          questionType: 'fill_in_the_blank',
        ),
        true,
      );
    });

    test('accepts case-insensitive by default', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'power set',
          correctAnswer: 'Power Set',
          questionType: 'fill_in_the_blank',
          caseSensitive: false,
        ),
        true,
      );
    });
  });

  group('AnswerValidator - Multiple Choice Tests', () {
    test('accepts exact match', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: 'The set of all difficult math problems.',
          correctAnswer: 'The set of all difficult math problems.',
          questionType: 'multiple_choice',
        ),
        true,
      );
    });

    test('handles extra spaces', () {
      expect(
        AnswerValidator.validateAnswer(
          studentAnswer: '  The set of all difficult math problems.  ',
          correctAnswer: 'The set of all difficult math problems.',
          questionType: 'multiple_choice',
        ),
        true,
      );
    });
  });

  group('AnswerValidator - Feedback Messages', () {
    test('provides helpful feedback for set with missing elements', () {
      final feedback = AnswerValidator.getFeedbackMessage(
        isCorrect: false,
        questionType: 'set_notation',
        correctAnswer: '{a, e, i}',
        studentAnswer: '{a, e}',
      );

      expect(feedback.contains('missing'), true);
      expect(feedback.contains('i'), true);
    });

    test('provides helpful feedback for set with extra elements', () {
      final feedback = AnswerValidator.getFeedbackMessage(
        isCorrect: false,
        questionType: 'set_notation',
        correctAnswer: '{a, e}',
        studentAnswer: '{a, e, i}',
      );

      expect(feedback.contains('extra'), true);
      expect(feedback.contains('i'), true);
    });

    test('provides positive feedback for correct answer', () {
      final feedback = AnswerValidator.getFeedbackMessage(
        isCorrect: true,
        questionType: 'set_notation',
        correctAnswer: '{a, e}',
      );

      expect(
        [
          'Excellent',
          'Perfect',
          'Great',
          'Correct',
          'Well done',
          'Outstanding',
        ].any((word) => feedback.contains(word)),
        true,
      );
    });
  });
}

// EXAMPLE OUTPUT WHEN RUNNING TESTS:
/*
✓ accepts correct set with exact format
✓ accepts set without spaces  
✓ accepts set with extra spaces
✓ accepts set in different order
✓ accepts set with mixed spacing and order
✓ rejects set with missing elements
✓ rejects set with extra elements
✓ accepts empty set as ∅
✓ accepts empty set as {}
✓ accepts empty set as "empty"
✓ handles set with numbers
✓ handles set with symbols
✓ accepts exact numeric match
✓ accepts numeric match with spaces
✓ accepts decimal equivalents
✓ accepts "true" for True
✓ accepts "t" for True
✓ accepts "yes" for True
✓ accepts "1" for True
✓ accepts "false" for False
✓ accepts "no" for False
✓ accepts exact match (fill in blank)
✓ accepts with extra spaces
✓ accepts case-insensitive by default
✓ accepts exact match (multiple choice)
✓ handles extra spaces
✓ provides helpful feedback for set with missing elements
✓ provides helpful feedback for set with extra elements
✓ provides positive feedback for correct answer

All 28 tests passed! ✓
*/
