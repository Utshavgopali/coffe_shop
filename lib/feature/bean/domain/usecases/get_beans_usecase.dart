import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/bean_repository.dart';
import '../repositories/bean_repository.dart';

class GetBeansParams {
  final int page;
  final int limit;
  final String search;
  final String category;
  final List<String> roastLevel;
  final List<String> origin;
  final double? minPrice;
  final double? maxPrice;
  final bool? featured;
  final String sort;

  const GetBeansParams({
    this.page = 1,
    this.limit = 12,
    this.search = '',
    this.category = '',
    this.roastLevel = const [],
    this.origin = const [],
    this.minPrice,
    this.maxPrice,
    this.featured,
    this.sort = '',
  });
}

final getBeansUsecaseProvider = Provider<GetBeansUsecase>(
  (ref) => GetBeansUsecase(ref.read(beanRepositoryProvider)),
);

class GetBeansUsecase implements UsecaseWithParams<BeanListResult, GetBeansParams> {
  final IBeanRepository _repository;

  GetBeansUsecase(this._repository);

  @override
  Future<Either<Failure, BeanListResult>> call(GetBeansParams params) {
    return _repository.getBeans(
      page: params.page,
      limit: params.limit,
      search: params.search,
      category: params.category,
      roastLevel: params.roastLevel,
      origin: params.origin,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      featured: params.featured,
      sort: params.sort,
    );
  }
}
