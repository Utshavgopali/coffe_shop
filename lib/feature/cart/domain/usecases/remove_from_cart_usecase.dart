import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/cart_repository.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

final removeFromCartUsecaseProvider = Provider<RemoveFromCartUsecase>(
  (ref) => RemoveFromCartUsecase(ref.read(cartRepositoryProvider)),
);

class RemoveFromCartUsecase implements UsecaseWithParams<CartEntity, String> {
  final ICartRepository _repository;

  RemoveFromCartUsecase(this._repository);

  @override
  Future<Either<Failure, CartEntity>> call(String beanId) => _repository.removeFromCart(beanId);
}
