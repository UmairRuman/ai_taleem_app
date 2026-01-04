// ============================================
// 4. CONCEPT EXAMPLE
// ============================================

class ConceptExample {
  final String title;
  final String problem;
  final String solution;
  final String explanation;

  ConceptExample({
    required this.title,
    required this.problem,
    required this.solution,
    required this.explanation,
  });

  factory ConceptExample.fromJson(Map<String, dynamic> json) {
    return ConceptExample(
      title: json['title'] as String? ?? '',
      problem: json['problem'] as String? ?? '',
      solution: json['solution'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'problem': problem,
      'solution': solution,
      'explanation': explanation,
    };
  }
}
