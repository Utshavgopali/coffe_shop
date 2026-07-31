import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

final checkoutUsecaseProvider = Provider<CheckoutUsecase>(
  (ref) => CheckoutUsecase(ref.read(orderRepositoryProvider)),
);

class CheckoutUsecase implements UsecaseWithParams<CheckoutResult, ShippingAddressEntity> {
  final IOrderRepository _repository;

  CheckoutUsecase(this._repository);

  @override
  Future<Either<Failure, CheckoutResult>> call(ShippingAddressEntity params) {
    return _repository.checkout(params);
  }
}
