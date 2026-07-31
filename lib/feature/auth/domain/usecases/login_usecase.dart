import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(ref.read(authRepositoryProvider));
});

class LoginUsecase implements UsecaseWithParams<AuthEntity, LoginUsecaseParams> {
  final IAuthRepository _repository;

  LoginUsecase(this._repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUsecaseParams params) {
    return _repository.login(params.email, params.password);
  }
}
