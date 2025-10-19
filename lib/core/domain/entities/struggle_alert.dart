import 'package:taleem_ai/core/domain/entities/teacher_remediation_tip.dart';

class StruggleAlert {
  final String alertId;
  final String studentId;
  final String studentName;
  final String conceptId;
  final String conceptTitle;
  final int gradeLevel;
  final int failureCount;
  final DateTime generatedAt;
  final List<TeacherRemediationTip> remediationTips;
  final bool isResolved;

  const StruggleAlert({
    required this.alertId,
    required this.studentId,
    required this.studentName,
    required this.conceptId,
    required this.conceptTitle,
    required this.gradeLevel,
    required this.failureCount,
    required this.generatedAt,
    required this.remediationTips,
    required this.isResolved,
  });

  StruggleAlert copyWith({
    String? alertId,
    String? studentId,
    String? studentName,
    String? conceptId,
    String? conceptTitle,
    int? gradeLevel,
    int? failureCount,
    DateTime? generatedAt,
    List<TeacherRemediationTip>? remediationTips,
    bool? isResolved,
  }) {
    return StruggleAlert(
      alertId: alertId ?? this.alertId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      conceptId: conceptId ?? this.conceptId,
      conceptTitle: conceptTitle ?? this.conceptTitle,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      failureCount: failureCount ?? this.failureCount,
      generatedAt: generatedAt ?? this.generatedAt,
      remediationTips: remediationTips ?? this.remediationTips,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}
