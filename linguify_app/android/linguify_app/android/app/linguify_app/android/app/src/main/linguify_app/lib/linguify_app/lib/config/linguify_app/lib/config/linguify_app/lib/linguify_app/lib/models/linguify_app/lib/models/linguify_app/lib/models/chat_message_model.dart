import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageRole { user, assistant }

class ChatMessageModel {
  final String id;
  final String userId;
  final String content;
  final MessageRole role;
  final DateTime createdAt;
  final bool isError;

  ChatMessageModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.role,
    required this.createdAt,
    this.isError = false,
  });

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      role: MessageRole.values.firstWhere(
        (e) => e.name == (data['role'] ?? 'user'),
        orElse: () => MessageRole.user,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isError: data['isError'] ?? false,
    );
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> data, String id) {
    return ChatMessageModel(
      id: id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      role: MessageRole.values.firstWhere(
        (e) => e.name == (data['role'] ?? 'user'),
        orElse: () => MessageRole.user,
      ),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isError: data['isError'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'content': content,
      'role': role.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isError': isError,
    };
  }

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;
}
