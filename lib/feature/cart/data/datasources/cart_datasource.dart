import '../models/cart_api_model.dart';

abstract interface class ICartRemoteDataSource {
  Future<CartApiModel> getCart();

  Future<CartApiModel> addToCart(String beanId, int quantity);

  Future<CartApiModel> updateCartItem(String beanId, int quantity);

  Future<CartApiModel> removeFromCart(String beanId);

  Future<void> clearCart();
}
