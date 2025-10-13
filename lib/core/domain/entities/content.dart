// lib/core/domain/entities/content.dart
class Content {
  final String? introduction;
  final String? definition;
  final List<Map<String, dynamic>>? examples;
  final List<Map<String, dynamic>>? forms;
  final String? membershipSymbols;
  final String? cardinality;
  final List<Map<String, dynamic>>? typesBySize;
  final List<Map<String, dynamic>>? comparison;
  final String? universalSet;
  final String? subsetSuperset;
  final String? properImproper;
  final List<Map<String, dynamic>>? operations;
  final List<Map<String, dynamic>>? laws;
  final List<Map<String, dynamic>>? properties;
  final String? formula;
  final String? example;

  Content({
    this.introduction,
    this.definition,
    this.examples,
    this.forms,
    this.membershipSymbols,
    this.cardinality,
    this.typesBySize,
    this.comparison,
    this.universalSet,
    this.subsetSuperset,
    this.properImproper,
    this.operations,
    this.laws,
    this.properties,
    this.formula,
    this.example,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      introduction: json['introduction'] as String?,
      definition: json['definition'] as String?,
      examples:
          (json['examples'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      forms:
          (json['forms'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      membershipSymbols: json['membership_symbols'] as String?,
      cardinality: json['cardinality'] as String?,
      typesBySize:
          (json['types_by_size'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      comparison:
          (json['comparison'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      universalSet: json['universal_set'] as String?,
      subsetSuperset: json['subset_superset'] as String?,
      properImproper: json['proper_improper'] as String?,
      operations:
          (json['operations'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      laws:
          (json['laws'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      properties:
          (json['properties'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      formula: json['formula'] as String?,
      example: json['example'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (introduction != null) 'introduction': introduction,
      if (definition != null) 'definition': definition,
      if (examples != null) 'examples': examples,
      if (forms != null) 'forms': forms,
      if (membershipSymbols != null) 'membership_symbols': membershipSymbols,
      if (cardinality != null) 'cardinality': cardinality,
      if (typesBySize != null) 'types_by_size': typesBySize,
      if (comparison != null) 'comparison': comparison,
      if (universalSet != null) 'universal_set': universalSet,
      if (subsetSuperset != null) 'subset_superset': subsetSuperset,
      if (properImproper != null) 'proper_improper': properImproper,
      if (operations != null) 'operations': operations,
      if (laws != null) 'laws': laws,
      if (properties != null) 'properties': properties,
      if (formula != null) 'formula': formula,
      if (example != null) 'example': example,
    };
  }
}
