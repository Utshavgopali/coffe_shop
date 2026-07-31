import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_datasource.dart';
import '../datasources/remote/order_remote_datasource.dart';
import '../models/order_api_model.dart';

final orderRepositoryProvider = Provider<IOrderRepository>(
  (ref) => OrderRepository(
    remoteDatasource: ref.read(orderRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

class OrderRepository implements IOrderRepository {
  final IOrderRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  OrderRepository({
    required IOrderRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, CheckoutResult>> checkout(ShippingAddressEntity shippingAddress) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to check out.'));
    }
    try {
      final result = await _remoteDatasource.checkout(
        ShippingAddressApiModel(
          fullName: shippingAddress.fullName,
          phone: shippingAddress.phone,
          city: shippingAddress.city,
          street: shippingAddress.street,
        ),
      );
      return Right(
        CheckoutResult(
          order: result.order.toEntity(),
          paymentUrl: result.paymentUrl,
          pidx: result.pidx,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Checkout failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> verifyPayment(String pidx) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to verify payment.'));
    }
    try {
      final result = await _remoteDatasource.verifyPayment(pidx);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Payment verification failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to see your orders.'));
    }
    try {
      final result = await _remoteDatasource.getMyOrders();
      return Right(result.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to load orders',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to see this order.'));
    }
    try {
      final result = await _remoteDatasource.getOrderById(id);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Order not found',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
