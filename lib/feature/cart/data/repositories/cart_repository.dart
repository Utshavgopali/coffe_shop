import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_datasource.dart';
import '../datasources/remote/cart_remote_datasource.dart';

final cartRepositoryProvider = Provider<ICartRepository>(
  (ref) => CartRepository(
    remoteDatasource: ref.read(cartRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

class CartRepository implements ICartRepository {
  final ICartRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  CartRepository({
    required ICartRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to see your cart.'));
    }
    try {
      final result = await _remoteDatasource.getCart();
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to load cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart(String beanId, int quantity) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to add to cart.'));
    }
    try {
      final result = await _remoteDatasource.addToCart(beanId, quantity);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to add to cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItem(String beanId, int quantity) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to update your cart.'));
    }
    try {
      final result = await _remoteDatasource.updateCartItem(beanId, quantity);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to update cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart(String beanId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to update your cart.'));
    }
    try {
      final result = await _remoteDatasource.removeFromCart(beanId);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to remove item',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearCart() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to clear your cart.'));
    }
    try {
      await _remoteDatasource.clearCart();
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to clear cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
