import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/notification_repository.dart';
import '../repositories/notification_repository.dart';

final markAllReadUsecaseProvider = Provider<MarkAllReadUsecase>(
  (ref) => MarkAllReadUsecase(ref.read(notificationRepositoryProvider)),
);

class MarkAllReadUsecase implements UsecaseWithoutParams<bool> {
  final INotificationRepository _repository;

  MarkAllReadUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call() => _repository.markAllAsRead();
}
