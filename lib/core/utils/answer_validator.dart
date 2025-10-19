// lib/core/utils/answer_validator.dart

class AnswerValidator {
  /// Validates student answer against correct answer
  /// Handles different question types and formats
  static bool validateAnswer({
    required String studentAnswer,
    required String correctAnswer,
    required String questionType,
    bool caseSensitive = false,
  }) {
    switch (questionType.toLowerCase()) {
      case 'multiple_choice':
        return _validateMultipleChoice(
          studentAnswer,
          correctAnswer,
          caseSensitive,
        );

      case 'fill_in_the_blank':
        return _validateFillInBlank(
          studentAnswer,
          correctAnswer,
          caseSensitive,
        );

      case 'short_answer':
        return _validateShortAnswer(
          studentAnswer,
          correctAnswer,
          caseSensitive,
        );

      case 'true_false':
        return _validateTrueFalse(studentAnswer, correctAnswer);

      case 'set_notation':
        return _validateSetNotation(studentAnswer, correctAnswer);

      default:
        return _validateGeneric(studentAnswer, correctAnswer, caseSensitive);
    }
  }

  /// Multiple choice - exact match (after normalization)
  static bool _validateMultipleChoice(
    String studentAnswer,
    String correctAnswer,
    bool caseSensitive,
  ) {
    return _normalizeText(studentAnswer, caseSensitive) ==
        _normalizeText(correctAnswer, caseSensitive);
  }

  /// Fill in blank - flexible matching
  static bool _validateFillInBlank(
    String studentAnswer,
    String correctAnswer,
    bool caseSensitive,
  ) {
    final student = _normalizeText(studentAnswer, caseSensitive);
    final correct = _normalizeText(correctAnswer, caseSensitive);

    // Direct match
    if (student == correct) return true;

    // Check if student answer contains all words from correct answer
    final correctWords = correct.split(' ');
    return correctWords.every((word) => student.contains(word));
  }

  /// Short answer - flexible matching for mathematical expressions
  static bool _validateShortAnswer(
    String studentAnswer,
    String correctAnswer,
    bool caseSensitive,
  ) {
    // Check if answer looks like a set notation
    if (_isSetNotation(correctAnswer)) {
      return _validateSetNotation(studentAnswer, correctAnswer);
    }

    // Check if answer is a number
    if (_isNumeric(correctAnswer)) {
      return _validateNumeric(studentAnswer, correctAnswer);
    }

    // Regular text comparison
    return _validateFillInBlank(studentAnswer, correctAnswer, caseSensitive);
  }

  /// True/False - flexible matching
  static bool _validateTrueFalse(String studentAnswer, String correctAnswer) {
    final student = studentAnswer.toLowerCase().trim();
    final correct = correctAnswer.toLowerCase().trim();

    // Direct match
    if (student == correct) return true;

    // Accept variations
    if (correct == 'true') {
      return ['true', 't', 'yes', 'y', '1', 'correct'].contains(student);
    } else if (correct == 'false') {
      return ['false', 'f', 'no', 'n', '0', 'incorrect'].contains(student);
    }

    return false;
  }

  /// Set notation validation - SMART ALGORITHM
  /// Handles: {a, e}, {a,e}, { a , e }, {e, a}, etc.
  static bool _validateSetNotation(String studentAnswer, String correctAnswer) {
    // Extract elements from both answers
    final studentElements = _extractSetElements(studentAnswer);
    final correctElements = _extractSetElements(correctAnswer);

    if (studentElements == null || correctElements == null) {
      return false;
    }

    // Sets are equal if they have same elements (order doesn't matter)
    return _setEquals(studentElements, correctElements);
  }

  /// Extract elements from set notation
  /// Example: "{a, b, c}" => ['a', 'b', 'c']
  static List<String>? _extractSetElements(String setNotation) {
    try {
      // Remove all whitespace first
      String cleaned = setNotation.trim();

      // Check for empty set variations
      if (cleaned == '∅' ||
          cleaned == '{}' ||
          cleaned.toLowerCase() == 'empty' ||
          cleaned.toLowerCase() == 'null') {
        return [];
      }

      // Must have curly braces for valid set notation
      if (!cleaned.startsWith('{') || !cleaned.endsWith('}')) {
        return null;
      }

      // Extract content between braces
      cleaned = cleaned.substring(1, cleaned.length - 1);

      // If empty after removing braces
      if (cleaned.trim().isEmpty) {
        return [];
      }

      // Split by comma and normalize each element
      final elements =
          cleaned
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .map((e) => _normalizeSetElement(e))
              .toList();

      return elements;
    } catch (e) {
      return null;
    }
  }

  /// Normalize a single set element
  static String _normalizeSetElement(String element) {
    // Remove all spaces
    String normalized = element.replaceAll(' ', '');

    // Handle special characters
    normalized = normalized.toLowerCase();

    return normalized;
  }

  /// Check if two sets are equal (order doesn't matter)
  static bool _setEquals(List<String> set1, List<String> set2) {
    if (set1.length != set2.length) return false;

    // Convert to Set for comparison (handles duplicates automatically)
    final s1 = Set<String>.from(set1);
    final s2 = Set<String>.from(set2);

    return s1.difference(s2).isEmpty && s2.difference(s1).isEmpty;
  }

  /// Validate numeric answers
  static bool _validateNumeric(String studentAnswer, String correctAnswer) {
    final studentNum = double.tryParse(studentAnswer.trim());
    final correctNum = double.tryParse(correctAnswer.trim());

    if (studentNum == null || correctNum == null) return false;

    // Allow small floating point differences
    return (studentNum - correctNum).abs() < 0.0001;
  }

  /// Check if string is a number
  static bool _isNumeric(String str) {
    return double.tryParse(str.trim()) != null;
  }

  /// Check if string looks like set notation
  static bool _isSetNotation(String str) {
    final trimmed = str.trim();
    return trimmed.startsWith('{') && trimmed.endsWith('}');
  }

  /// Normalize text for comparison
  static String _normalizeText(String text, bool caseSensitive) {
    String normalized = text.trim();

    // Remove extra spaces
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    if (!caseSensitive) {
      normalized = normalized.toLowerCase();
    }

    return normalized;
  }

  /// Generic validation
  static bool _validateGeneric(
    String studentAnswer,
    String correctAnswer,
    bool caseSensitive,
  ) {
    return _normalizeText(studentAnswer, caseSensitive) ==
        _normalizeText(correctAnswer, caseSensitive);
  }

  /// Get feedback message based on answer correctness
  static String getFeedbackMessage({
    required bool isCorrect,
    required String questionType,
    required String correctAnswer,
    String? studentAnswer,
  }) {
    if (isCorrect) {
      return _getCorrectFeedback(questionType);
    } else {
      return _getIncorrectFeedback(questionType, correctAnswer, studentAnswer);
    }
  }

  static String _getCorrectFeedback(String questionType) {
    final messages = [
      'Excellent! 🎉',
      'Perfect! ⭐',
      'Great job! 👏',
      'Correct! ✓',
      'Well done! 💯',
      'Outstanding! 🌟',
    ];
    messages.shuffle();
    return messages.first;
  }

  static String _getIncorrectFeedback(
    String questionType,
    String correctAnswer,
    String? studentAnswer,
  ) {
    if (questionType == 'set_notation' && studentAnswer != null) {
      final studentElements = _extractSetElements(studentAnswer);
      final correctElements = _extractSetElements(correctAnswer);

      if (studentElements != null && correctElements != null) {
        final missing =
            correctElements.where((e) => !studentElements.contains(e)).toList();
        final extra =
            studentElements.where((e) => !correctElements.contains(e)).toList();

        if (missing.isNotEmpty && extra.isEmpty) {
          return 'Close! You\'re missing: ${missing.join(', ')}';
        } else if (extra.isNotEmpty && missing.isEmpty) {
          return 'Almost! You have extra elements: ${extra.join(', ')}';
        } else if (missing.isNotEmpty && extra.isNotEmpty) {
          return 'Not quite. Missing: ${missing.join(', ')}, Extra: ${extra.join(', ')}';
        }
      }
    }

    return 'Not quite right. The correct answer is: $correctAnswer';
  }
}

// USAGE EXAMPLES:

/*
// Example 1: Set notation (handles spaces and order)
AnswerValidator.validateAnswer(
  studentAnswer: '{a, e}',      // or '{a,e}' or '{ a , e }' or '{e, a}'
  correctAnswer: '{a, e}',
  questionType: 'set_notation',
); // Returns: true

// Example 2: Empty set
AnswerValidator.validateAnswer(
  studentAnswer: '∅',            // or '{}' or 'empty'
  correctAnswer: '{}',
  questionType: 'set_notation',
); // Returns: true

// Example 3: Number
AnswerValidator.validateAnswer(
  studentAnswer: '42',
  correctAnswer: '42.0',
  questionType: 'short_answer',
); // Returns: true

// Example 4: Text with spaces
AnswerValidator.validateAnswer(
  studentAnswer: '  Power Set  ',
  correctAnswer: 'Power Set',
  questionType: 'fill_in_the_blank',
); // Returns: true

// Example 5: True/False
AnswerValidator.validateAnswer(
  studentAnswer: 'yes',          // or 'true' or 't' or '1'
  correctAnswer: 'True',
  questionType: 'true_false',
); // Returns: true
*/
