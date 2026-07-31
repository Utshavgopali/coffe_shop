import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_hive_model.dart';

final authLocalDatasourceProvider = Provider<IAuthDataSource>(
  (ref) => AuthLocalDatasource(),
);

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    remoteDatasource: ref.read(authRemoteDataSourceProvider),
    localDatasource: ref.read(authLocalDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class AuthRepository implements IAuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final IAuthDataSource _localDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
    required IAuthDataSource localDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _networkInfo = networkInfo;

  // ================= REGISTER =================

  @override
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          message: 'No internet connection. Connect to create an account.',
        ),
      );
    }

    try {
      final model = await _remoteDatasource.register(
        name: name,
        email: email,
        password: password,
      );
      await _localDatasource.saveUser(AuthHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Registration failed'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= LOGIN =================

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to log in.'),
      );
    }

    try {
      final model = await _remoteDatasource.login(email, password);
      await _localDatasource.saveUser(AuthHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Invalid email or password'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= GOOGLE LOGIN =================

  @override
  Future<Either<Failure, AuthEntity>> loginWithGoogle(String idToken) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to sign in with Google.'),
      );
    }

    try {
      final model = await _remoteDatasource.googleLogin(idToken);
      await _localDatasource.saveUser(AuthHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Google sign-in failed'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= GET CURRENT USER =================
  // Online: verify against /auth/whoami — authoritative. A 401 means the
  // token is dead, so the cache is cleared too (no point restoring a
  // session that will just fail on the next real request). Any other
  // online failure (timeout, DNS blip mid-request) falls back to the
  // cache instead of forcing a logout for what might just be a hiccup.
  // Offline: go straight to the cache.

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDatasource.getCurrentUser();
        await _localDatasource.saveUser(AuthHiveModel.fromEntity(model.toEntity()));
        return Right(model.toEntity());
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          await _localDatasource.clearSession();
          return const Left(
            ApiFailure(
              statusCode: 401,
              message: 'Your session is no longer valid. Please log in again.',
            ),
          );
        }
        // fall through to the cache for anything else
      } catch (_) {
        // fall through to the cache
      }
    }

    final cached = await _localDatasource.getCachedUser();
    if (cached == null) {
      return const Left(LocalDatabaseFailure(message: 'No user logged in'));
    }
    return Right(cached.toEntity());
  }

  // ================= LOGOUT =================
  // No backend logout endpoint exists — this is purely local (discard the
  // stored token + cached profile).

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _remoteDatasource.logout();
      await _localDatasource.clearSession();
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= UPDATE PROFILE =================

  @override
  Future<Either<Failure, AuthEntity>> updateProfile({
    String? name,
    File? avatarFile,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          message: 'No internet connection. Connect to update your profile.',
        ),
      );
    }

    try {
      final model = await _remoteDatasource.updateProfile(
        name: name,
        avatarFile: avatarFile,
      );
      await _localDatasource.saveUser(AuthHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Failed to update profile'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= FORGOT PASSWORD =================
  // All three steps always require a live connection — there's no
  // meaningful offline version of "email me a reset code".

  @override
  Future<Either<Failure, bool>> forgotPasswordRequest(String email) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to request a reset code.'),
      );
    }
    try {
      await _remoteDatasource.forgotPasswordRequest(email);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Failed to send reset code'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPasswordVerify(String email, String code) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to verify your code.'),
      );
    }
    try {
      await _remoteDatasource.forgotPasswordVerify(email, code);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Invalid or expired code'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPasswordReset(
    String email,
    String code,
    String newPassword,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to reset your password.'),
      );
    }
    try {
      await _remoteDatasource.forgotPasswordReset(email, code, newPassword);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Failed to reset password'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= CHANGE PASSWORD =================

  @override
  Future<Either<Failure, bool>> changePasswordRequestCode(String currentPassword) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to request a code.'),
      );
    }
    try {
      await _remoteDatasource.changePasswordRequestCode(currentPassword);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Failed to send verification code'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePasswordConfirm(String code, String newPassword) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to change your password.'),
      );
    }
    try {
      await _remoteDatasource.changePasswordConfirm(code, newPassword);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractMessage(e, 'Failed to change password'),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return fallback;
  }
}
