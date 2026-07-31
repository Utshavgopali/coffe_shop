import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileParams extends Equatable {
  final String? name;
  final File? avatarFile;

  const UpdateProfileParams({this.name, this.avatarFile});

  @override
  List<Object?> get props => [name, avatarFile];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(ref.read(authRepositoryProvider));
});

class UpdateProfileUsecase
    implements UsecaseWithParams<AuthEntity, UpdateProfileParams> {
  final IAuthRepository _repository;

  UpdateProfileUsecase(this._repository);

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      name: params.name,
      avatarFile: params.avatarFile,
    );
  }
}
