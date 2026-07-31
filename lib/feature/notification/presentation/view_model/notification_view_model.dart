import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../state/notification_state.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationsState>(NotificationViewModel.new);

class NotificationViewModel extends Notifier<NotificationsState> {
  late GetNotificationsUsecase _getNotificationsUsecase;
  late MarkNotificationReadUsecase _markNotificationReadUsecase;
  late MarkAllReadUsecase _markAllReadUsecase;

  @override
  NotificationsState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    _markNotificationReadUsecase = ref.read(markNotificationReadUsecaseProvider);
    _markAllReadUsecase = ref.read(markAllReadUsecaseProvider);
    return const NotificationsState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(status: NotificationStatus.loading, errorMessage: null);

    final result = await _getNotificationsUsecase();

    result.fold(
      (failure) => state = state.copyWith(status: NotificationStatus.error, errorMessage: failure.message),
      (data) => state = state.copyWith(
        status: NotificationStatus.loaded,
        notifications: data.notifications,
        unread: data.unread,
      ),
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await _markNotificationReadUsecase(id);

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (updated) {
        final updatedList = state.notifications.map((n) => n.id == id ? updated : n).toList();
        final newUnread = updatedList.where((n) => !n.read).length;
        state = state.copyWith(notifications: updatedList, unread: newUnread);
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _markAllReadUsecase();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        final updatedList = state.notifications.map((n) => n.copyWith(read: true)).toList();
        state = state.copyWith(notifications: updatedList, unread: 0);
      },
    );
  }

  void clearCache() {
    state = const NotificationsState();
  }
}
