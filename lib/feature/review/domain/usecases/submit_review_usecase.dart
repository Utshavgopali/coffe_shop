import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/review_repository.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class SubmitReviewParams extends Equatable {
  final String beanId;
  final int rating;
  final String comment;

  const SubmitReviewParams({
    required this.beanId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [beanId, rating, comment];
}

final submitReviewUsecaseProvider = Provider<SubmitReviewUsecase>(
  (ref) => SubmitReviewUsecase(ref.read(reviewRepositoryProvider)),
);

class SubmitReviewUsecase implements UsecaseWithParams<ReviewEntity, SubmitReviewParams> {
  final IReviewRepository _repository;

  SubmitReviewUsecase(this._repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(SubmitReviewParams params) {
    return _repository.submitReview(
      beanId: params.beanId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}
