import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/concept.dart';
import '../domain/entities/remediation_recommendation.dart';
import '../domain/entities/struggle_alert.dart';
import '../domain/entities/student_progress.dart';

/// Pedagogically-Driven Rules Engine for Adaptive Learning
class AdaptiveEngineService {
  static const int _passingPercentage = 70;
  static const int _struggleThreshold = 2;

  final Uuid _uuid = const Uuid();

  /// Evaluates if a student passed the quiz
  bool hasPassedQuiz(int score, int totalQuestions) {
    final percentage = (score / totalQuestions) * 100;
    return percentage >= _passingPercentage;
  }

  /// Records a quiz attempt and updates student progress
  StudentProgress recordQuizAttempt({
    required StudentProgress? existingProgress,
    required String studentId,
    required String conceptId,
    required int score,
    required int totalQuestions,
  }) {
    final passed = hasPassedQuiz(score, totalQuestions);
    final percentage = (score / totalQuestions) * 100;

    final attempt = QuizAttempt(
      attemptId: _uuid.v4(),
      attemptDate: DateTime.now(),
      score: score,
      totalQuestions: totalQuestions,
      passed: passed,
      percentage: percentage,
    );

    if (existingProgress == null) {
      return StudentProgress(
        studentId: studentId,
        conceptId: conceptId,
        attemptCount: 1,
        failureCount: passed ? 0 : 1,
        lastAttemptDate: DateTime.now(),
        attempts: [attempt],
        needsRemediation: !passed,
      );
    }

    final newAttempts = [...existingProgress.attempts, attempt];
    final newFailureCount =
        passed
            ? existingProgress.failureCount
            : existingProgress.failureCount + 1;

    return existingProgress.copyWith(
      attemptCount: existingProgress.attemptCount + 1,
      failureCount: newFailureCount,
      lastAttemptDate: DateTime.now(),
      attempts: newAttempts,
      needsRemediation: newFailureCount >= _struggleThreshold,
    );
  }

  /// Checks if a struggle alert should be generated
  bool shouldGenerateStruggleAlert(StudentProgress progress) {
    return progress.failureCount >= _struggleThreshold &&
        progress.needsRemediation;
  }

  /// Generates a struggle alert for teachers
  StruggleAlert generateStruggleAlert({
    required StudentProgress progress,
    required Concept concept,
    required String studentName,
  }) {
    return StruggleAlert(
      alertId: _uuid.v4(),
      studentId: progress.studentId,
      studentName: studentName,
      conceptId: concept.conceptId,
      conceptTitle: concept.title,
      gradeLevel: concept.gradeLevel,
      failureCount: progress.failureCount,
      generatedAt: DateTime.now(),
      remediationTips: concept.teacherRemediationTip,
      isResolved: false,
    );
  }

  /// Generates remediation recommendations based on prerequisites
  RemediationRecommendation generateRemediationRecommendation({
    required Concept failedConcept,
    required List<Concept> allConcepts,
  }) {
    // Find all prerequisite concepts
    final prerequisiteConcepts = <PrerequisiteConcept>[];

    for (final prereqId in failedConcept.prerequisites) {
      // Find the concept
      final concept = allConcepts.firstWhere(
        (c) => c.conceptId == prereqId,
        orElse:
            () => throw Exception('Prerequisite concept not found: $prereqId'),
      );

      // Find the matching remediation tip
      final tip = failedConcept.teacherRemediationTip.firstWhere(
        (t) => t.prerequisiteId == prereqId,
        orElse:
            () => TeacherRemediationTip(
              prerequisiteId: prereqId,
              tip:
                  'Review the ${concept.title} lesson from Grade ${concept.gradeLevel}.',
            ),
      );

      prerequisiteConcepts.add(
        PrerequisiteConcept(
          conceptId: concept.conceptId,
          title: concept.title,
          gradeLevel: concept.gradeLevel,
          remediationTip: tip.tip,
        ),
      );
    }

    return RemediationRecommendation(
      conceptId: failedConcept.conceptId,
      conceptTitle: failedConcept.title,
      gradeLevel: failedConcept.gradeLevel,
      prerequisiteIds: failedConcept.prerequisites,
      prerequisiteConcepts: prerequisiteConcepts,
      reason:
          'Student struggled with ${failedConcept.title}. Reviewing these prerequisite concepts may help.',
      generatedAt: DateTime.now(),
    );
  }

  /// Analyzes student progress and determines next action
  AdaptiveResponse analyzeProgress({
    required StudentProgress progress,
    required Concept concept,
    required List<Concept> allConcepts,
    required String studentName,
  }) {
    if (shouldGenerateStruggleAlert(progress)) {
      final alert = generateStruggleAlert(
        progress: progress,
        concept: concept,
        studentName: studentName,
      );

      final recommendation = generateRemediationRecommendation(
        failedConcept: concept,
        allConcepts: allConcepts,
      );

      return AdaptiveResponse(
        needsRemediation: true,
        struggleAlert: alert,
        recommendation: recommendation,
        message:
            'You\'ve attempted this concept ${progress.failureCount} times. Let\'s review some foundational concepts that will help you succeed.',
      );
    }

    if (progress.needsRemediation && progress.failureCount == 1) {
      final recommendation = generateRemediationRecommendation(
        failedConcept: concept,
        allConcepts: allConcepts,
      );

      return AdaptiveResponse(
        needsRemediation: true,
        recommendation: recommendation,
        message:
            'Let\'s review some prerequisite concepts to help you master ${concept.title}.',
      );
    }

    return AdaptiveResponse(
      needsRemediation: false,
      message: 'Keep up the great work!',
    );
  }
}

class AdaptiveResponse {
  final bool needsRemediation;
  final StruggleAlert? struggleAlert;
  final RemediationRecommendation? recommendation;
  final String message;

  const AdaptiveResponse({
    required this.needsRemediation,
    this.struggleAlert,
    this.recommendation,
    required this.message,
  });
}
