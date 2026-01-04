// ============================================
// 7. PRACTICE QUIZ QUESTION
// ============================================

class PracticeQuizQuestion {
  final String questionId;
  final String bloomLevel;
  final String questionType;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final List<String> commonMisconceptions;
  final String difficulty;

  PracticeQuizQuestion({
    required this.questionId,
    required this.bloomLevel,
    required this.questionType,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.commonMisconceptions,
    required this.difficulty,
  });

  factory PracticeQuizQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuizQuestion(
      questionId: json['question_id'] as String? ?? json['questionId'] as String? ?? '',
      bloomLevel: json['bloom_level'] as String? ?? json['bloomLevel'] as String? ?? '',
      questionType: json['question_type'] as String? ?? json['questionType'] as String? ?? '',
      questionText: json['question_text'] as String? ?? json['questionText'] as String? ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] as String? ?? json['correctAnswer'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      commonMisconceptions: List<String>.from(
        json['common_misconceptions'] ?? json['commonMisconceptions'] ?? [],
      ),
      difficulty: json['difficulty'] as String? ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'bloomLevel': bloomLevel,
      'questionType': questionType,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'commonMisconceptions': commonMisconceptions,
      'difficulty': difficulty,
    };
  }
}