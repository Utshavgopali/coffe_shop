import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordConfirmParams extends Equatable {
  final String code;
  final String newPassword;

  const ChangePasswordConfirmParams({required this.code, required this.newPassword});

  @override
  List<Object?> get props => [code, newPassword];
}

final changePasswordConfirmUsecaseProvider = Provider<ChangePasswordConfirmUsecase>(
  (ref) => ChangePasswordConfirmUsecase(ref.read(authRepositoryProvider)),
);

class ChangePasswordConfirmUsecase
    implements UsecaseWithParams<bool, ChangePasswordConfirmParams> {
  final IAuthRepository _repository;

  ChangePasswordConfirmUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordConfirmParams params) {
    return _repository.changePasswordConfirm(params.code, params.newPassword);
  }
}
