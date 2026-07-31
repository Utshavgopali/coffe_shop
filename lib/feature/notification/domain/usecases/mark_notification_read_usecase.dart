import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/notification_repository.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

final markNotificationReadUsecaseProvider = Provider<MarkNotificationReadUsecase>(
  (ref) => MarkNotificationReadUsecase(ref.read(notificationRepositoryProvider)),
);

class MarkNotificationReadUsecase implements UsecaseWithParams<NotificationEntity, String> {
  final INotificationRepository _repository;

  MarkNotificationReadUsecase(this._repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(String id) => _repository.markAsRead(id);
}
