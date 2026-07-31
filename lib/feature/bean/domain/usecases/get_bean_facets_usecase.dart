import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/bean_repository.dart';
import '../entities/bean_facets_entity.dart';
import '../repositories/bean_repository.dart';

final getBeanFacetsUsecaseProvider = Provider<GetBeanFacetsUsecase>(
  (ref) => GetBeanFacetsUsecase(ref.read(beanRepositoryProvider)),
);

class GetBeanFacetsUsecase implements UsecaseWithParams<BeanFacetsEntity, String?> {
  final IBeanRepository _repository;

  GetBeanFacetsUsecase(this._repository);

  @override
  Future<Either<Failure, BeanFacetsEntity>> call(String? category) {
    return _repository.getFacets(category: category);
  }
}
