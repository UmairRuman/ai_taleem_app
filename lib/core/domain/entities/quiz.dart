// lib/core/domain/entities/practice_quiz.dart
class PracticeQuiz {
  final String questionId;
  final String type;
  final String questionText;
  final List<String>? options;
  final String correctAnswer;
  final String feedback;

  PracticeQuiz({
    required this.questionId,
    required this.type,
    required this.questionText,
    this.options,
    required this.correctAnswer,
    required this.feedback,
  });

  factory PracticeQuiz.fromMap(Map<String, dynamic> json) {
    return PracticeQuiz(
      questionId: json['question_id'] as String,
      type: json['type'] as String,
      questionText: json['question_text'] as String,
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correct_answer'] as String,
      feedback: json['feedback'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'type': type,
      'question_text': questionText,
      if (options != null) 'options': options,
      'correct_answer': correctAnswer,
      'feedback': feedback,
    };
  }
}
