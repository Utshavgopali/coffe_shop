import '../models/review_api_model.dart';

class ReviewRemoteListResult {
  final List<ReviewApiModel> reviews;
  final ReviewSummaryApiModel summary;

  const ReviewRemoteListResult({required this.reviews, required this.summary});
}

abstract interface class IReviewRemoteDataSource {
  Future<ReviewRemoteListResult> getReviewsForBean(
    String beanId, {
    required int page,
    required int limit,
  });

  Future<ReviewApiModel?> getMyReview(String beanId);

  Future<ReviewApiModel> submitReview({
    required String beanId,
    required int rating,
    required String comment,
  });

  Future<void> deleteReview(String beanId);
}
