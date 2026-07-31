import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String beanId;
  final String name;
  final int weightGrams;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.beanId,
    required this.name,
    required this.weightGrams,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [beanId, name, weightGrams, price, quantity];
}

class ShippingAddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String city;
  final String street;

  const ShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.city,
    required this.street,
  });

  @override
  List<Object?> get props => [fullName, phone, city, street];
}

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status; // pending | paid | failed | cancelled
  final String paymentMethod;
  final String? khaltiPidx;
  final ShippingAddressEntity shippingAddress;
  final DateTime? createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.khaltiPidx,
    required this.shippingAddress,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        totalAmount,
        status,
        paymentMethod,
        khaltiPidx,
        shippingAddress,
        createdAt,
      ];
}
