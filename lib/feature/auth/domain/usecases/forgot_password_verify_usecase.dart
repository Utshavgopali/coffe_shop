import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordVerifyParams extends Equatable {
  final String email;
  final String code;

  const ForgotPasswordVerifyParams({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}

final forgotPasswordVerifyUsecaseProvider = Provider<ForgotPasswordVerifyUsecase>(
  (ref) => ForgotPasswordVerifyUsecase(ref.read(authRepositoryProvider)),
);

class ForgotPasswordVerifyUsecase
    implements UsecaseWithParams<bool, ForgotPasswordVerifyParams> {
  final IAuthRepository _repository;

  ForgotPasswordVerifyUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ForgotPasswordVerifyParams params) {
    return _repository.forgotPasswordVerify(params.email, params.code);
  }
}
