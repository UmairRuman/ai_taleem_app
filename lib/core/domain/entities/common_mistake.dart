// ============================================
// 5. COMMON MISTAKE
// ============================================

class CommonMistake {
  final String mistake;
  final String whyWrong;
  final String correctApproach;

  CommonMistake({
    required this.mistake,
    required this.whyWrong,
    required this.correctApproach,
  });

  factory CommonMistake.fromJson(Map<String, dynamic> json) {
    return CommonMistake(
      mistake: json['mistake'] as String? ?? '',
      whyWrong: json['why_wrong'] as String? ?? json['whyWrong'] as String? ?? '',
      correctApproach: json['correct_approach'] as String? ?? json['correctApproach'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mistake': mistake,
      'whyWrong': whyWrong,
      'correctApproach': correctApproach,
    };
  }
}