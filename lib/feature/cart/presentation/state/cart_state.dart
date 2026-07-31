import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = const CartEntity.empty(),
    this.errorMessage,
  });

  int get itemCount => cart.totalItems;

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}
