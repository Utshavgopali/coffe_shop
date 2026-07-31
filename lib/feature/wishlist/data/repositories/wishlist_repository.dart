import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/remote/wishlist_remote_datasource.dart';
import '../datasources/wishlist_datasource.dart';

final wishlistRepositoryProvider = Provider<IWishlistRepository>(
  (ref) => WishlistRepository(
    remoteDatasource: ref.read(wishlistRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

class WishlistRepository implements IWishlistRepository {
  final IWishlistRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  WishlistRepository({
    required IWishlistRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<WishlistEntity>>> getWishlist() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to see your wishlist.'),
      );
    }

    try {
      final result = await _remoteDatasource.getWishlist();
      return Right(result.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to load wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addToWishlist(String beanId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to add to wishlist.'),
      );
    }

    try {
      await _remoteDatasource.addToWishlist(beanId);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to add to wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromWishlist(String beanId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to remove from wishlist.'),
      );
    }

    try {
      await _remoteDatasource.removeFromWishlist(beanId);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to remove from wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
