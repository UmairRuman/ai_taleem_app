// Path: lib/core/domain/entities/quiz.dart

class Question {
  final String id;
  final String text;
  final String? textUrdu;
  final String
  type; // "multiple_choice" | "true_false" | "fill_in_the_blank" | "short_answer" | "mcq"
  final List<String>? options;
  final List<String>? optionsUrdu;
  final String correctAnswer;
  final String explanation;
  final String? explanationUrdu;
  final int points;

  Question({
    required this.id,
    required this.text,
    this.textUrdu,
    required this.type,
    this.options,
    this.optionsUrdu,
    required this.correctAnswer,
    required this.explanation,
    this.explanationUrdu,
    required this.points,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as String,
      text: map['text'] as String,
      textUrdu: map['textUrdu'] as String?,
      type: map['type'] as String,
      options:
          map['options'] != null ? List<String>.from(map['options']) : null,
      optionsUrdu:
          map['optionsUrdu'] != null
              ? List<String>.from(map['optionsUrdu'])
              : null,
      correctAnswer: map['correctAnswer'] as String,
      explanation: map['explanation'] as String,
      explanationUrdu: map['explanationUrdu'] as String?,
      points: map['points'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'textUrdu': textUrdu,
      'type': type,
      'options': options,
      'optionsUrdu': optionsUrdu,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'explanationUrdu': explanationUrdu,
      'points': points,
    };
  }
}

// Note: Quiz class can remain if needed for separate quizzes, but for MVP, practice_quiz is embedded in Concept
