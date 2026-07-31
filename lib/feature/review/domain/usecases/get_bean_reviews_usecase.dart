import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/review_repository.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

final getBeanReviewsUsecaseProvider = Provider<GetBeanReviewsUsecase>(
  (ref) => GetBeanReviewsUsecase(ref.read(reviewRepositoryProvider)),
);

class GetBeanReviewsUsecase implements UsecaseWithParams<BeanReviewsResult, String> {
  final IReviewRepository _repository;

  GetBeanReviewsUsecase(this._repository);

  @override
  Future<Either<Failure, BeanReviewsResult>> call(String beanId) {
    return _repository.getReviewsForBean(beanId);
  }
}
