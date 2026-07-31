import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/cart_repository.dart';
import '../repositories/cart_repository.dart';

final clearCartUsecaseProvider = Provider<ClearCartUsecase>(
  (ref) => ClearCartUsecase(ref.read(cartRepositoryProvider)),
);

class ClearCartUsecase implements UsecaseWithoutParams<bool> {
  final ICartRepository _repository;

  ClearCartUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call() => _repository.clearCart();
}
