import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_entity.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unread;
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unread = 0,
    this.errorMessage,
  });

  NotificationsState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unread,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unread: unread ?? this.unread,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, unread, errorMessage];
}
