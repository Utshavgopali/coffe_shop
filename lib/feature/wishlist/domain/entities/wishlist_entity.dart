import 'package:equatable/equatable.dart';

import '../../../bean/domain/entities/bean_entity.dart';

class WishlistEntity extends Equatable {
  final String id;
  final BeanEntity bean;
  final DateTime? createdAt;

  const WishlistEntity({required this.id, required this.bean, this.createdAt});

  @override
  List<Object?> get props => [id, bean, createdAt];
}
