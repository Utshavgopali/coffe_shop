import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/review_repository.dart';
import '../repositories/review_repository.dart';

final deleteReviewUsecaseProvider = Provider<DeleteReviewUsecase>(
  (ref) => DeleteReviewUsecase(ref.read(reviewRepositoryProvider)),
);

class DeleteReviewUsecase implements UsecaseWithParams<bool, String> {
  final IReviewRepository _repository;

  DeleteReviewUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String beanId) {
    return _repository.deleteReview(beanId);
  }
}
