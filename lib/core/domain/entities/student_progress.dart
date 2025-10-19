class StudentProgress {
  final String studentId;
  final String conceptId;
  final int attemptCount;
  final int failureCount;
  final DateTime lastAttemptDate;
  final List<QuizAttempt> attempts;
  final bool needsRemediation;

  const StudentProgress({
    required this.studentId,
    required this.conceptId,
    required this.attemptCount,
    required this.failureCount,
    required this.lastAttemptDate,
    required this.attempts,
    required this.needsRemediation,
  });

  StudentProgress copyWith({
    String? studentId,
    String? conceptId,
    int? attemptCount,
    int? failureCount,
    DateTime? lastAttemptDate,
    List<QuizAttempt>? attempts,
    bool? needsRemediation,
  }) {
    return StudentProgress(
      studentId: studentId ?? this.studentId,
      conceptId: conceptId ?? this.conceptId,
      attemptCount: attemptCount ?? this.attemptCount,
      failureCount: failureCount ?? this.failureCount,
      lastAttemptDate: lastAttemptDate ?? this.lastAttemptDate,
      attempts: attempts ?? this.attempts,
      needsRemediation: needsRemediation ?? this.needsRemediation,
    );
  }
}

class QuizAttempt {
  final String attemptId;
  final DateTime attemptDate;
  final int score;
  final int totalQuestions;
  final bool passed;
  final double percentage;

  const QuizAttempt({
    required this.attemptId,
    required this.attemptDate,
    required this.score,
    required this.totalQuestions,
    required this.passed,
    required this.percentage,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      attemptId: json['attemptId'] as String,
      attemptDate: DateTime.parse(json['attemptDate'] as String),
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      passed: json['passed'] as bool,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attemptId': attemptId,
      'attemptDate': attemptDate.toIso8601String(),
      'score': score,
      'totalQuestions': totalQuestions,
      'passed': passed,
      'percentage': percentage,
    };
  }
}
