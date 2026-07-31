import '../../../bean/data/models/bean_api_model.dart';
import '../../domain/entities/wishlist_entity.dart';

class WishlistApiModel {
  final String id;
  final BeanApiModel bean;
  final DateTime? createdAt;

  const WishlistApiModel({required this.id, required this.bean, this.createdAt});

  factory WishlistApiModel.fromJson(Map<String, dynamic> json) {
    return WishlistApiModel(
      id: (json['id'] ?? json['_id']) as String,
      bean: BeanApiModel.fromJson(json['bean'] as Map<String, dynamic>),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  WishlistEntity toEntity() {
    return WishlistEntity(id: id, bean: bean.toEntity(), createdAt: createdAt);
  }
}
