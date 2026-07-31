import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/cart_repository.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

final getCartUsecaseProvider = Provider<GetCartUsecase>(
  (ref) => GetCartUsecase(ref.read(cartRepositoryProvider)),
);

class GetCartUsecase implements UsecaseWithoutParams<CartEntity> {
  final ICartRepository _repository;

  GetCartUsecase(this._repository);

  @override
  Future<Either<Failure, CartEntity>> call() => _repository.getCart();
}
