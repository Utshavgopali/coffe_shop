import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, CartEntity>> getCart();

  Future<Either<Failure, CartEntity>> addToCart(String beanId, int quantity);

  Future<Either<Failure, CartEntity>> updateCartItem(String beanId, int quantity);

  Future<Either<Failure, CartEntity>> removeFromCart(String beanId);

  Future<Either<Failure, bool>> clearCart();
}
