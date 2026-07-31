import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/notification_repository.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>(
  (ref) => GetNotificationsUsecase(ref.read(notificationRepositoryProvider)),
);

class GetNotificationsUsecase implements UsecaseWithoutParams<NotificationListResult> {
  final INotificationRepository _repository;

  GetNotificationsUsecase(this._repository);

  @override
  Future<Either<Failure, NotificationListResult>> call() => _repository.getNotifications();
}
