import 'package:equatable/equatable.dart';

import '../../domain/entities/wishlist_entity.dart';

enum WishlistStatus { initial, loading, loaded, error }

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<WishlistEntity> items;
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  bool isWishlisted(String beanId) => items.any((i) => i.bean.id == beanId);

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistEntity>? items,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
