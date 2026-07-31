import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, NotificationListResult>> getNotifications();

  Future<Either<Failure, NotificationEntity>> markAsRead(String id);

  Future<Either<Failure, bool>> markAllAsRead();
}
