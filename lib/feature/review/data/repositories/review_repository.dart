import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/remote/review_remote_datasource.dart';
import '../datasources/review_datasource.dart';

final reviewRepositoryProvider = Provider<IReviewRepository>(
  (ref) => ReviewRepository(
    remoteDatasource: ref.read(reviewRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

class ReviewRepository implements IReviewRepository {
  final IReviewRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  ReviewRepository({
    required IReviewRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, BeanReviewsResult>> getReviewsForBean(
    String beanId, {
    int page = 1,
    int limit = 10,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to see reviews.'),
      );
    }

    try {
      final result = await _remoteDatasource.getReviewsForBean(
        beanId,
        page: page,
        limit: limit,
      );

      return Right(
        BeanReviewsResult(
          reviews: result.reviews.map((m) => m.toEntity()).toList(),
          summary: result.summary.toEntity(),
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to load reviews',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity?>> getMyReview(String beanId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }

    try {
      final result = await _remoteDatasource.getMyReview(beanId);
      return Right(result?.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Right(null);
      }
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to load your review',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String beanId,
    required int rating,
    required String comment,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to submit a review.'),
      );
    }

    try {
      final result = await _remoteDatasource.submitReview(
        beanId: beanId,
        rating: rating,
        comment: comment,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to submit review',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReview(String beanId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to delete your review.'),
      );
    }

    try {
      await _remoteDatasource.deleteReview(beanId);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to delete review',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
