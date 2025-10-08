// Path: lib/core/domain/entities/content.dart
class Content {
  final String? introduction;
  final String? definition;
  final List<Map<String, dynamic>>? examples;
  final List<Map<String, dynamic>>? forms; // For G6_Notation
  final String? membershipSymbols; // For G6_Notation
  final List<Map<String, dynamic>>? typesBySize; // For G6_Classification
  final List<Map<String, dynamic>>? comparison; // For G6_Classification
  final String? cardinality; // For G6_Classification
  final String? universalSet; // For G6_Subsets
  final String? subsetSuperset; // For G6_Subsets
  final String? properImproper; // For G6_Subsets
  final List<Map<String, dynamic>>? operations; // For G7_SetOperations
  final String? formula; // For G8_WordProblems
  final String? example; // For various concepts
  final List<Map<String, dynamic>>? laws; // For G7_DeMorgansIntro
  final List<Map<String, dynamic>>? properties; // For G8_SetProperties
  final List<Map<String, dynamic>>? practiceQuiz; // Embedded quizzes

  Content({
    this.introduction,
    this.definition,
    this.examples,
    this.forms,
    this.membershipSymbols,
    this.typesBySize,
    this.comparison,
    this.cardinality,
    this.universalSet,
    this.subsetSuperset,
    this.properImproper,
    this.operations,
    this.formula,
    this.example,
    this.laws,
    this.properties,
    this.practiceQuiz,
  });

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      introduction: map['introduction'] as String?,
      definition: map['definition'] as String?,
      examples:
          (map['examples'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      forms:
          (map['forms'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      membershipSymbols: map['membership_symbols'] as String?,
      typesBySize:
          (map['types_by_size'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      comparison:
          (map['comparison'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      cardinality: map['cardinality'] as String?,
      universalSet: map['universal_set'] as String?,
      subsetSuperset: map['subset_superset'] as String?,
      properImproper: map['proper_improper'] as String?,
      operations:
          (map['operations'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      formula: map['formula'] as String?,
      example: map['example'] as String?,
      laws:
          (map['laws'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      properties:
          (map['properties'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
      practiceQuiz:
          (map['practice_quiz'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (introduction != null) 'introduction': introduction,
      if (definition != null) 'definition': definition,
      if (examples != null) 'examples': examples,
      if (forms != null) 'forms': forms,
      if (membershipSymbols != null) 'membership_symbols': membershipSymbols,
      if (typesBySize != null) 'types_by_size': typesBySize,
      if (comparison != null) 'comparison': comparison,
      if (cardinality != null) 'cardinality': cardinality,
      if (universalSet != null) 'universal_set': universalSet,
      if (subsetSuperset != null) 'subset_superset': subsetSuperset,
      if (properImproper != null) 'proper_improper': properImproper,
      if (operations != null) 'operations': operations,
      if (formula != null) 'formula': formula,
      if (example != null) 'example': example,
      if (laws != null) 'laws': laws,
      if (properties != null) 'properties': properties,
      if (practiceQuiz != null) 'practice_quiz': practiceQuiz,
    };
  }
}
