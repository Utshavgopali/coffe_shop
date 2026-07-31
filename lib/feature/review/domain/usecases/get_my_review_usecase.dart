import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/review_repository.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

final getMyReviewUsecaseProvider = Provider<GetMyReviewUsecase>(
  (ref) => GetMyReviewUsecase(ref.read(reviewRepositoryProvider)),
);

class GetMyReviewUsecase implements UsecaseWithParams<ReviewEntity?, String> {
  final IReviewRepository _repository;

  GetMyReviewUsecase(this._repository);

  @override
  Future<Either<Failure, ReviewEntity?>> call(String beanId) {
    return _repository.getMyReview(beanId);
  }
}
