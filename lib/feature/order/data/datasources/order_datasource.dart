import '../models/order_api_model.dart';

class CheckoutRemoteResult {
  final OrderApiModel order;
  final String paymentUrl;
  final String pidx;

  const CheckoutRemoteResult({required this.order, required this.paymentUrl, required this.pidx});
}

abstract interface class IOrderRemoteDataSource {
  Future<CheckoutRemoteResult> checkout(ShippingAddressApiModel shippingAddress);

  Future<OrderApiModel> verifyPayment(String pidx);

  Future<List<OrderApiModel>> getMyOrders();

  Future<OrderApiModel> getOrderById(String id);
}
