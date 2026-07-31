import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/review_api_model.dart';
import '../review_datasource.dart';

final reviewRemoteDatasourceProvider = Provider<IReviewRemoteDataSource>(
  (ref) => ReviewRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class ReviewRemoteDatasource implements IReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDatasource({required this.apiClient});

  @override
  Future<ReviewRemoteListResult> getReviewsForBean(
    String beanId, {
    required int page,
    required int limit,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.beanReviews(beanId),
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final List<dynamic> rawReviews = data['reviews'] ?? [];

    return ReviewRemoteListResult(
      reviews: rawReviews.map((json) => ReviewApiModel.fromJson(json)).toList(),
      summary: ReviewSummaryApiModel.fromJson(
        data['summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  Future<ReviewApiModel?> getMyReview(String beanId) async {
    final response = await apiClient.get(ApiEndpoints.myBeanReview(beanId));
    final data = response.data['data'];
    if (data == null) return null;
    return ReviewApiModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ReviewApiModel> submitReview({
    required String beanId,
    required int rating,
    required String comment,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.beanReviews(beanId),
      data: {'rating': rating, 'comment': comment},
    );
    return ReviewApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteReview(String beanId) async {
    await apiClient.delete(ApiEndpoints.beanReviews(beanId));
  }
}
