import '../../domain/entities/order_entity.dart';

class OrderItemApiModel {
  final String beanId;
  final String name;
  final int weightGrams;
  final double price;
  final int quantity;

  const OrderItemApiModel({
    required this.beanId,
    required this.name,
    required this.weightGrams,
    required this.price,
    required this.quantity,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    final beanField = json['bean'];
    return OrderItemApiModel(
      beanId: beanField is Map ? (beanField['_id'] ?? beanField['id'] ?? '') as String : (beanField ?? '') as String,
      name: json['name'] as String? ?? '',
      weightGrams: (json['weightGrams'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  OrderItemEntity toEntity() => OrderItemEntity(
        beanId: beanId,
        name: name,
        weightGrams: weightGrams,
        price: price,
        quantity: quantity,
      );
}

class ShippingAddressApiModel {
  final String fullName;
  final String phone;
  final String city;
  final String street;

  const ShippingAddressApiModel({
    required this.fullName,
    required this.phone,
    required this.city,
    required this.street,
  });

  factory ShippingAddressApiModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressApiModel(
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      street: json['street'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'city': city,
        'street': street,
      };

  ShippingAddressEntity toEntity() =>
      ShippingAddressEntity(fullName: fullName, phone: phone, city: city, street: street);
}

class OrderApiModel {
  final String id;
  final List<OrderItemApiModel> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String? khaltiPidx;
  final ShippingAddressApiModel shippingAddress;
  final DateTime? createdAt;

  const OrderApiModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.khaltiPidx,
    required this.shippingAddress,
    this.createdAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems = json['items'] ?? [];
    return OrderApiModel(
      id: (json['id'] ?? json['_id']) as String,
      items: rawItems.map((json) => OrderItemApiModel.fromJson(json)).toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['paymentMethod'] as String? ?? 'khalti',
      khaltiPidx: json['khaltiPidx'] as String?,
      shippingAddress: ShippingAddressApiModel.fromJson(
        json['shippingAddress'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      items: items.map((i) => i.toEntity()).toList(),
      totalAmount: totalAmount,
      status: status,
      paymentMethod: paymentMethod,
      khaltiPidx: khaltiPidx,
      shippingAddress: shippingAddress.toEntity(),
      createdAt: createdAt,
    );
  }
}
