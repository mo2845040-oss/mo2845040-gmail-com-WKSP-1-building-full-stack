import 'package:cloud_firestore/cloud_firestore.dart';

enum LessonLevel { beginner, intermediate, advanced }

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final LessonLevel level;
  final String videoUrl;
  final String thumbnailUrl;
  final int durationSeconds;
  final String teacherId;
  final String teacherName;
  final List<String> keywords;
  final int totalStudents;
  final double averageRating;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.teacherId,
    required this.teacherName,
    required this.keywords,
    this.totalStudents = 0,
    this.averageRating = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LessonModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      level: LessonLevel.values.firstWhere(
        (e) => e.name == (data['level'] ?? 'beginner'),
        orElse: () => LessonLevel.beginner,
      ),
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      durationSeconds: data['durationSeconds'] ?? 0,
      teacherId: data['teacherId'] ?? '',
      teacherName: data['teacherName'] ?? '',
      keywords: List<String>.from(data['keywords'] ?? []),
      totalStudents: data['totalStudents'] ?? 0,
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'level': level.name,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'durationSeconds': durationSeconds,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'keywords': keywords,
      'totalStudents': totalStudents,
      'averageRating': averageRating,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  LessonModel copyWith({
    String? title,
    String? description,
    String? category,
    LessonLevel? level,
    String? videoUrl,
    String? thumbnailUrl,
    int? durationSeconds,
    List<String>? keywords,
    int? totalStudents,
    double? averageRating,
    DateTime? updatedAt,
  }) {
    return LessonModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      teacherId: teacherId,
      teacherName: teacherName,
      keywords: keywords ?? this.keywords,
      totalStudents: totalStudents ?? this.totalStudents,
      averageRating: averageRating ?? this.averageRating,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get levelLabel => level.name[0].toUpperCase() + level.name.substring(1);
  String get durationFormatted {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
