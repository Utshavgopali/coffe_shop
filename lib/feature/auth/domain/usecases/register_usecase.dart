import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterUsecaseParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return RegisterUsecase(ref.read(authRepositoryProvider));
});

class RegisterUsecase
    implements UsecaseWithParams<AuthEntity, RegisterUsecaseParams> {
  final IAuthRepository _repository;

  RegisterUsecase(this._repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterUsecaseParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
