import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

final googleLoginUsecaseProvider = Provider<GoogleLoginUsecase>((ref) {
  return GoogleLoginUsecase(ref.read(authRepositoryProvider));
});

class GoogleLoginUsecase implements UsecaseWithParams<AuthEntity, String> {
  final IAuthRepository _repository;

  GoogleLoginUsecase(this._repository);

  @override
  Future<Either<Failure, AuthEntity>> call(String idToken) {
    return _repository.loginWithGoogle(idToken);
  }
}
