// ============================================
// 9. SEARCH INDEX
// For quick lookups
// ============================================

class SearchIndex {
  final Map<String, List<String>> byGrade;
  final Map<String, List<String>> byTopic;
  final Map<String, List<String>> byDifficulty;
  final List<String> withUrdu;

  SearchIndex({
    required this.byGrade,
    required this.byTopic,
    required this.byDifficulty,
    required this.withUrdu,
  });

  factory SearchIndex.fromFirestore(Map<String, dynamic> json) {
    return SearchIndex(
      byGrade: (json['byGrade'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
      byTopic: (json['byTopic'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
      byDifficulty: (json['byDifficulty'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
      withUrdu: List<String>.from(json['withUrdu'] ?? []),
    );
  }

  // Get concept IDs for a specific grade
  List<String> getConceptsByGrade(int grade) {
    return byGrade[grade.toString()] ?? [];
  }

  // Get concept IDs for a specific topic
  List<String> getConceptsByTopic(String topic) {
    return byTopic[topic] ?? [];
  }

  // Get concept IDs with Urdu available
  List<String> getConceptsWithUrdu() {
    return withUrdu;
  }
}