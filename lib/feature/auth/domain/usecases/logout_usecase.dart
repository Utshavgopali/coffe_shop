import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(ref.read(authRepositoryProvider));
});

class LogoutUsecase implements UsecaseWithoutParams<bool> {
  final IAuthRepository _repository;

  LogoutUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call() => _repository.logout();
}
