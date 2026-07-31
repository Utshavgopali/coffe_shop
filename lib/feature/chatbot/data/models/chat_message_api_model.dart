import '../../domain/entities/chat_message_entity.dart';

class ChatMessageApiModel {
  final String id;
  final ChatRole role;
  final String content;
  final DateTime? createdAt;

  const ChatMessageApiModel({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  factory ChatMessageApiModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageApiModel(
      id: (json['id'] ?? json['_id']) as String,
      role: (json['role'] as String?) == 'assistant' ? ChatRole.assistant : ChatRole.user,
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(id: id, role: role, content: content, createdAt: createdAt);
  }
}
