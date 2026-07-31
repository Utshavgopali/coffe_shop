import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/bean_repository.dart';
import '../entities/bean_entity.dart';
import '../repositories/bean_repository.dart';

final getBeanByIdUsecaseProvider = Provider<GetBeanByIdUsecase>(
  (ref) => GetBeanByIdUsecase(ref.read(beanRepositoryProvider)),
);

class GetBeanByIdUsecase implements UsecaseWithParams<BeanEntity, String> {
  final IBeanRepository _repository;

  GetBeanByIdUsecase(this._repository);

  @override
  Future<Either<Failure, BeanEntity>> call(String id) {
    return _repository.getBeanById(id);
  }
}
