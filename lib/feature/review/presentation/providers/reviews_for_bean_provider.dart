import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/review_entity.dart';
import '../../domain/usecases/get_bean_reviews_usecase.dart';
import '../../domain/usecases/get_my_review_usecase.dart';

// Riverpod caches one result per beanId automatically. When a review is
// submitted/deleted, ReviewActionViewModel calls
// ref.invalidate(reviewsForBeanProvider(beanId)) to force a fresh fetch.
final reviewsForBeanProvider =
    FutureProvider.family<BeanReviewsResult, String>((ref, beanId) async {
  final usecase = ref.read(getBeanReviewsUsecaseProvider);
  final result = await usecase(beanId);

  return result.fold(
    (failure) => throw failure,
    (data) => data,
  );
});

final myReviewProvider = FutureProvider.family<ReviewEntity?, String>((ref, beanId) async {
  final usecase = ref.read(getMyReviewUsecaseProvider);
  final result = await usecase(beanId);

  return result.fold(
    (failure) => throw failure,
    (data) => data,
  );
});
