import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final String type; // order | account | system
  final bool read;
  final DateTime? createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    this.createdAt,
  });

  NotificationEntity copyWith({bool? read}) {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      read: read ?? this.read,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, message, type, read, createdAt];
}

class NotificationListResult extends Equatable {
  final List<NotificationEntity> notifications;
  final int unread;

  const NotificationListResult({required this.notifications, required this.unread});

  @override
  List<Object?> get props => [notifications, unread];
}
