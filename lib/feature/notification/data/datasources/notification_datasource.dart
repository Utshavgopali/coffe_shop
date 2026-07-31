import '../models/notification_api_model.dart';

class NotificationRemoteListResult {
  final List<NotificationApiModel> notifications;
  final int unread;

  const NotificationRemoteListResult({required this.notifications, required this.unread});
}

abstract interface class INotificationRemoteDataSource {
  Future<NotificationRemoteListResult> getNotifications();

  Future<NotificationApiModel> markAsRead(String id);

  Future<void> markAllAsRead();
}
