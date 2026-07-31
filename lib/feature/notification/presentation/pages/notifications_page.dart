import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../state/notification_state.dart';
import '../view_model/notification_view_model.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationViewModelProvider.notifier).loadNotifications());
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'account':
        return Icons.person_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('notifications', lang),
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, color: AppColors.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (state.unread > 0)
            TextButton(
              onPressed: () => ref.read(notificationViewModelProvider.notifier).markAllAsRead(),
              child: Text(AppStrings.get('markAllRead', lang), style: const TextStyle(color: AppColors.primary, fontFamily: 'Montserrat')),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationViewModelProvider.notifier).loadNotifications(),
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(NotificationsState state) {
    final lang = ref.read(localeViewModelProvider).language;

    if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.status == NotificationStatus.error && state.notifications.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              state.errorMessage ?? AppStrings.get('somethingWentWrong', lang),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
        ],
      );
    }

    if (state.notifications.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              AppStrings.get('noNotificationsYet', lang),
              style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: notification.read ? context.appSurface : AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Icon(_iconFor(notification.type), color: AppColors.primary, size: 18),
            ),
            title: Text(
              notification.title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: notification.read ? FontWeight.w500 : FontWeight.w700,
                color: context.appTextPrimary,
              ),
            ),
            subtitle: Text(
              notification.message,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: context.appTextSecondary),
            ),
            trailing: notification.read
                ? null
                : Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  ),
            onTap: notification.read
                ? null
                : () => ref.read(notificationViewModelProvider.notifier).markAsRead(notification.id),
          ),
        );
      },
    );
  }
}
