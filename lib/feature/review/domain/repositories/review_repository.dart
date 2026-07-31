import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/review_entity.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, BeanReviewsResult>> getReviewsForBean(
    String beanId, {
    int page,
    int limit,
  });

  Future<Either<Failure, ReviewEntity?>> getMyReview(String beanId);

  Future<Either<Failure, ReviewEntity>> submitReview({
    required String beanId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, bool>> deleteReview(String beanId);
}
