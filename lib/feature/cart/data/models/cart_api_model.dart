import '../../../bean/data/models/bean_api_model.dart';
import '../../domain/entities/cart_entity.dart';

class CartItemApiModel {
  final BeanApiModel bean;
  final int quantity;

  const CartItemApiModel({required this.bean, required this.quantity});

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    return CartItemApiModel(
      bean: BeanApiModel.fromJson(json['bean'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  CartItemEntity toEntity() => CartItemEntity(bean: bean.toEntity(), quantity: quantity);
}

class CartApiModel {
  final String id;
  final List<CartItemApiModel> items;

  const CartApiModel({required this.id, required this.items});

  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems = json['items'] ?? [];
    return CartApiModel(
      id: (json['id'] ?? json['_id']) as String? ?? '',
      items: rawItems.map((json) => CartItemApiModel.fromJson(json)).toList(),
    );
  }

  CartEntity toEntity() {
    return CartEntity(id: id, items: items.map((i) => i.toEntity()).toList());
  }
}
