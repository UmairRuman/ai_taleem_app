// lib/core/domain/entities/teacher_remediation_tip.dart
class TeacherRemediationTip {
  final String prerequisiteId;
  final String tip;

  TeacherRemediationTip({required this.prerequisiteId, required this.tip});

  factory TeacherRemediationTip.fromJson(Map<String, dynamic> json) {
    return TeacherRemediationTip(
      prerequisiteId: json['prerequisite_id'] as String,
      tip: json['tip'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'prerequisite_id': prerequisiteId, 'tip': tip};
  }
}
