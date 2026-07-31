import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/order_api_model.dart';
import '../order_datasource.dart';

final orderRemoteDatasourceProvider = Provider<IOrderRemoteDataSource>(
  (ref) => OrderRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class OrderRemoteDatasource implements IOrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDatasource({required this.apiClient});

  @override
  Future<CheckoutRemoteResult> checkout(ShippingAddressApiModel shippingAddress) async {
    final response = await apiClient.post(ApiEndpoints.checkout, data: shippingAddress.toJson());
    final data = response.data['data'] as Map<String, dynamic>;

    return CheckoutRemoteResult(
      order: OrderApiModel.fromJson(data['order'] as Map<String, dynamic>),
      paymentUrl: data['paymentUrl'] as String,
      pidx: data['pidx'] as String,
    );
  }

  @override
  Future<OrderApiModel> verifyPayment(String pidx) async {
    final response = await apiClient.get(
      ApiEndpoints.verifyOrder,
      queryParameters: {'pidx': pidx},
    );
    return OrderApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<OrderApiModel>> getMyOrders() async {
    final response = await apiClient.get(ApiEndpoints.orders);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => OrderApiModel.fromJson(json)).toList();
  }

  @override
  Future<OrderApiModel> getOrderById(String id) async {
    final response = await apiClient.get(ApiEndpoints.orderById(id));
    return OrderApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
