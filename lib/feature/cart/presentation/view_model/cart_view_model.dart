import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(CartViewModel.new);

class CartViewModel extends Notifier<CartState> {
  late GetCartUsecase _getCartUsecase;
  late AddToCartUsecase _addToCartUsecase;
  late UpdateCartItemUsecase _updateCartItemUsecase;
  late RemoveFromCartUsecase _removeFromCartUsecase;
  late ClearCartUsecase _clearCartUsecase;

  @override
  CartState build() {
    _getCartUsecase = ref.read(getCartUsecaseProvider);
    _addToCartUsecase = ref.read(addToCartUsecaseProvider);
    _updateCartItemUsecase = ref.read(updateCartItemUsecaseProvider);
    _removeFromCartUsecase = ref.read(removeFromCartUsecaseProvider);
    _clearCartUsecase = ref.read(clearCartUsecaseProvider);
    return const CartState();
  }

  Future<void> loadCart() async {
    state = state.copyWith(status: CartStatus.loading, errorMessage: null);

    final result = await _getCartUsecase();

    result.fold(
      (failure) => state = state.copyWith(status: CartStatus.error, errorMessage: failure.message),
      (cart) => state = state.copyWith(status: CartStatus.loaded, cart: cart),
    );
  }

  Future<bool> addToCart(String beanId, {int quantity = 1}) async {
    final result = await _addToCartUsecase(AddToCartParams(beanId: beanId, quantity: quantity));

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (cart) {
        state = state.copyWith(status: CartStatus.loaded, cart: cart, errorMessage: null);
        return true;
      },
    );
  }

  Future<bool> updateQuantity(String beanId, int quantity) async {
    final result = await _updateCartItemUsecase(
      UpdateCartItemParams(beanId: beanId, quantity: quantity),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (cart) {
        state = state.copyWith(status: CartStatus.loaded, cart: cart, errorMessage: null);
        return true;
      },
    );
  }

  Future<bool> removeItem(String beanId) async {
    final result = await _removeFromCartUsecase(beanId);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (cart) {
        state = state.copyWith(status: CartStatus.loaded, cart: cart, errorMessage: null);
        return true;
      },
    );
  }

  Future<void> clearCart() async {
    final result = await _clearCartUsecase();
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) => state = state.copyWith(status: CartStatus.loaded, cart: const CartEntity.empty()),
    );
  }

  // Called on logout so a different account on this device doesn't briefly
  // see this user's cart before the next loadCart() call.
  void clearCache() {
    state = const CartState();
  }
}
