import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/cart_api_model.dart';
import '../cart_datasource.dart';

final cartRemoteDatasourceProvider = Provider<ICartRemoteDataSource>(
  (ref) => CartRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class CartRemoteDatasource implements ICartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDatasource({required this.apiClient});

  @override
  Future<CartApiModel> getCart() async {
    final response = await apiClient.get(ApiEndpoints.cart);
    return CartApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CartApiModel> addToCart(String beanId, int quantity) async {
    final response = await apiClient.post(
      ApiEndpoints.cart,
      data: {'beanId': beanId, 'quantity': quantity},
    );
    return CartApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CartApiModel> updateCartItem(String beanId, int quantity) async {
    final response = await apiClient.put(
      ApiEndpoints.cartItem(beanId),
      data: {'quantity': quantity},
    );
    return CartApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CartApiModel> removeFromCart(String beanId) async {
    final response = await apiClient.delete(ApiEndpoints.cartItem(beanId));
    return CartApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> clearCart() async {
    await apiClient.delete(ApiEndpoints.cart);
  }
}
