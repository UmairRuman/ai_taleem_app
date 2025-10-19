class RemediationRecommendation {
  final String conceptId;
  final String conceptTitle;
  final int gradeLevel;
  final List<String> prerequisiteIds;
  final List<PrerequisiteConcept> prerequisiteConcepts;
  final String reason;
  final DateTime generatedAt;

  const RemediationRecommendation({
    required this.conceptId,
    required this.conceptTitle,
    required this.gradeLevel,
    required this.prerequisiteIds,
    required this.prerequisiteConcepts,
    required this.reason,
    required this.generatedAt,
  });
}

class PrerequisiteConcept {
  final String conceptId;
  final String title;
  final int gradeLevel;
  final String remediationTip;

  const PrerequisiteConcept({
    required this.conceptId,
    required this.title,
    required this.gradeLevel,
    required this.remediationTip,
  });
}
