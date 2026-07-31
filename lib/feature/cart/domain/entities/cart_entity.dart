import 'package:equatable/equatable.dart';

import '../../../bean/domain/entities/bean_entity.dart';

class CartItemEntity extends Equatable {
  final BeanEntity bean;
  final int quantity;

  const CartItemEntity({required this.bean, required this.quantity});

  double get subtotal => bean.price * quantity;

  @override
  List<Object?> get props => [bean, quantity];
}

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;

  const CartEntity({required this.id, required this.items});

  const CartEntity.empty()
      : id = '',
        items = const [];

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0, (sum, item) => sum + item.subtotal);

  @override
  List<Object?> get props => [id, items];
}
