import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> login(String email, String password);

  Future<Either<Failure, AuthEntity>> loginWithGoogle(String idToken);

  Future<Either<Failure, AuthEntity>> getCurrentUser();

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, AuthEntity>> updateProfile({
    String? name,
    File? avatarFile,
  });

  Future<Either<Failure, bool>> forgotPasswordRequest(String email);

  Future<Either<Failure, bool>> forgotPasswordVerify(String email, String code);

  Future<Either<Failure, bool>> forgotPasswordReset(
    String email,
    String code,
    String newPassword,
  );

  Future<Either<Failure, bool>> changePasswordRequestCode(String currentPassword);

  Future<Either<Failure, bool>> changePasswordConfirm(String code, String newPassword);
}
