import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/cart_repository.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartParams extends Equatable {
  final String beanId;
  final int quantity;

  const AddToCartParams({required this.beanId, this.quantity = 1});

  @override
  List<Object?> get props => [beanId, quantity];
}

final addToCartUsecaseProvider = Provider<AddToCartUsecase>(
  (ref) => AddToCartUsecase(ref.read(cartRepositoryProvider)),
);

class AddToCartUsecase implements UsecaseWithParams<CartEntity, AddToCartParams> {
  final ICartRepository _repository;

  AddToCartUsecase(this._repository);

  @override
  Future<Either<Failure, CartEntity>> call(AddToCartParams params) {
    return _repository.addToCart(params.beanId, params.quantity);
  }
}
