import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/cart_repository.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemParams extends Equatable {
  final String beanId;
  final int quantity;

  const UpdateCartItemParams({required this.beanId, required this.quantity});

  @override
  List<Object?> get props => [beanId, quantity];
}

final updateCartItemUsecaseProvider = Provider<UpdateCartItemUsecase>(
  (ref) => UpdateCartItemUsecase(ref.read(cartRepositoryProvider)),
);

class UpdateCartItemUsecase implements UsecaseWithParams<CartEntity, UpdateCartItemParams> {
  final ICartRepository _repository;

  UpdateCartItemUsecase(this._repository);

  @override
  Future<Either<Failure, CartEntity>> call(UpdateCartItemParams params) {
    return _repository.updateCartItem(params.beanId, params.quantity);
  }
}
