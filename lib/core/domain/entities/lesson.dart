// Path: lib/core/domain/entities/lesson.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Example {
  final String text;
  final String textUrdu;
  final String? imageUrl;

  Example({required this.text, required this.textUrdu, this.imageUrl});

  factory Example.fromMap(Map<String, dynamic> map) {
    return Example(
      text: map['text'] as String,
      textUrdu: map['textUrdu'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'textUrdu': textUrdu, 'imageUrl': imageUrl};
  }
}

class Lesson {
  final String id;
  final String conceptId;
  final String title;
  final String titleUrdu;
  final String content;
  final String contentUrdu;
  final int grade;
  final String topic;
  final int order;
  final List<Example> examples;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.conceptId,
    required this.title,
    required this.titleUrdu,
    required this.content,
    required this.contentUrdu,
    required this.grade,
    required this.topic,
    required this.order,
    required this.examples,
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as String,
      conceptId: map['conceptId'] as String,
      title: map['title'] as String,
      titleUrdu: map['titleUrdu'] as String,
      content: map['content'] as String,
      contentUrdu: map['contentUrdu'] as String,
      grade: map['grade'] as int,
      topic: map['topic'] as String,
      order: map['order'] as int,
      examples:
          (map['examples'] as List<dynamic>? ?? [])
              .map((e) => Example.fromMap(e as Map<String, dynamic>))
              .toList(),
      videoUrl: map['videoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conceptId': conceptId,
      'title': title,
      'titleUrdu': titleUrdu,
      'content': content,
      'contentUrdu': contentUrdu,
      'grade': grade,
      'topic': topic,
      'order': order,
      'examples': examples.map((e) => e.toMap()).toList(),
      'videoUrl': videoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
