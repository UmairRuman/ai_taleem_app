class ConceptMetadata {
  final String conceptId;
  final String topic;
  final int gradeLevel;
  final int sequenceOrder;
  final int estimatedTimeMinutes;
  final String difficultyLevel;
  final List<String> prerequisites;
  final List<String> definesGlossaryTerms;
  
  // UI optimization hints
  final bool hasImages;
  final bool hasInteractiveElements;
  final int quizQuestionCount;
  final bool hasExamples;
  final bool hasCommonMistakes;
  final int keyPointsCount;
  
  // Available translations
  final List<String> availableLanguages;
  
  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ConceptMetadata({
    required this.conceptId,
    required this.topic,
    required this.gradeLevel,
    required this.sequenceOrder,
    required this.estimatedTimeMinutes,
    required this.difficultyLevel,
    required this.prerequisites,
    required this.definesGlossaryTerms,
    required this.hasImages,
    required this.hasInteractiveElements,
    required this.quizQuestionCount,
    required this.hasExamples,
    required this.hasCommonMistakes,
    required this.keyPointsCount,
    required this.availableLanguages,
    this.createdAt,
    this.updatedAt,
  });

  // Check if Urdu is available
  bool get hasUrdu => availableLanguages.contains('ur');
  
  // Check if this concept has prerequisites
  bool get hasPrerequisites => prerequisites.isNotEmpty;

  factory ConceptMetadata.fromFirestore(Map<String, dynamic> json) {
    return ConceptMetadata(
      conceptId: json['conceptId'] as String,
      topic: json['topic'] as String,
      gradeLevel: json['gradeLevel'] as int,
      sequenceOrder: json['sequenceOrder'] as int,
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int,
      difficultyLevel: json['difficultyLevel'] as String,
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      definesGlossaryTerms: List<String>.from(json['definesGlossaryTerms'] ?? []),
      hasImages: json['hasImages'] as bool? ?? false,
      hasInteractiveElements: json['hasInteractiveElements'] as bool? ?? false,
      quizQuestionCount: json['quizQuestionCount'] as int? ?? 0,
      hasExamples: json['hasExamples'] as bool? ?? false,
      hasCommonMistakes: json['hasCommonMistakes'] as bool? ?? false,
      keyPointsCount: json['keyPointsCount'] as int? ?? 0,
      availableLanguages: List<String>.from(json['availableLanguages'] ?? ['en']),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'conceptId': conceptId,
      'topic': topic,
      'gradeLevel': gradeLevel,
      'sequenceOrder': sequenceOrder,
      'estimatedTimeMinutes': estimatedTimeMinutes,
      'difficultyLevel': difficultyLevel,
      'prerequisites': prerequisites,
      'definesGlossaryTerms': definesGlossaryTerms,
      'hasImages': hasImages,
      'hasInteractiveElements': hasInteractiveElements,
      'quizQuestionCount': quizQuestionCount,
      'hasExamples': hasExamples,
      'hasCommonMistakes': hasCommonMistakes,
      'keyPointsCount': keyPointsCount,
      'availableLanguages': availableLanguages,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}