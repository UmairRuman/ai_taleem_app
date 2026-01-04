// ============================================
// 6. INTERACTIVE ELEMENT
// ============================================

class InteractiveElement {
  final String type;
  final String id;
  final String title;
  final String question;
  final String answer;
  final String hint;

  InteractiveElement({
    required this.type,
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.hint,
  });

  factory InteractiveElement.fromJson(Map<String, dynamic> json) {
    return InteractiveElement(
      type: json['type'] as String? ?? '',
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'question': question,
      'answer': answer,
      'hint': hint,
    };
  }
}