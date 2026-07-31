import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

class CheckoutResult {
  final OrderEntity order;
  final String paymentUrl;
  final String pidx;

  const CheckoutResult({required this.order, required this.paymentUrl, required this.pidx});
}

abstract interface class IOrderRepository {
  Future<Either<Failure, CheckoutResult>> checkout(ShippingAddressEntity shippingAddress);

  Future<Either<Failure, OrderEntity>> verifyPayment(String pidx);

  Future<Either<Failure, List<OrderEntity>>> getMyOrders();

  Future<Either<Failure, OrderEntity>> getOrderById(String id);
}
