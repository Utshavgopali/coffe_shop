import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

final forgotPasswordRequestUsecaseProvider = Provider<ForgotPasswordRequestUsecase>(
  (ref) => ForgotPasswordRequestUsecase(ref.read(authRepositoryProvider)),
);

class ForgotPasswordRequestUsecase implements UsecaseWithParams<bool, String> {
  final IAuthRepository _repository;

  ForgotPasswordRequestUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String email) => _repository.forgotPasswordRequest(email);
}
