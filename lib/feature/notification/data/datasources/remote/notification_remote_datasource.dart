import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/notification_api_model.dart';
import '../notification_datasource.dart';

final notificationRemoteDatasourceProvider = Provider<INotificationRemoteDataSource>(
  (ref) => NotificationRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class NotificationRemoteDatasource implements INotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDatasource({required this.apiClient});

  @override
  Future<NotificationRemoteListResult> getNotifications() async {
    final response = await apiClient.get(ApiEndpoints.notifications);
    final data = response.data['data'] as Map<String, dynamic>;
    final List<dynamic> rawNotifications = data['notifications'] ?? [];

    return NotificationRemoteListResult(
      notifications: rawNotifications.map((json) => NotificationApiModel.fromJson(json)).toList(),
      unread: (data['unread'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<NotificationApiModel> markAsRead(String id) async {
    final response = await apiClient.patch(ApiEndpoints.notificationRead(id));
    return NotificationApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> markAllAsRead() async {
    await apiClient.patch(ApiEndpoints.notificationsReadAll);
  }
}
