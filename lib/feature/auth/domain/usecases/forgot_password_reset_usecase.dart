import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordResetParams extends Equatable {
  final String email;
  final String code;
  final String newPassword;

  const ForgotPasswordResetParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, code, newPassword];
}

final forgotPasswordResetUsecaseProvider = Provider<ForgotPasswordResetUsecase>(
  (ref) => ForgotPasswordResetUsecase(ref.read(authRepositoryProvider)),
);

class ForgotPasswordResetUsecase implements UsecaseWithParams<bool, ForgotPasswordResetParams> {
  final IAuthRepository _repository;

  ForgotPasswordResetUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ForgotPasswordResetParams params) {
    return _repository.forgotPasswordReset(params.email, params.code, params.newPassword);
  }
}
