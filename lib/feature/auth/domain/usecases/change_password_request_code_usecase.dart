import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

final changePasswordRequestCodeUsecaseProvider = Provider<ChangePasswordRequestCodeUsecase>(
  (ref) => ChangePasswordRequestCodeUsecase(ref.read(authRepositoryProvider)),
);

class ChangePasswordRequestCodeUsecase implements UsecaseWithParams<bool, String> {
  final IAuthRepository _repository;

  ChangePasswordRequestCodeUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String currentPassword) {
    return _repository.changePasswordRequestCode(currentPassword);
  }
}
