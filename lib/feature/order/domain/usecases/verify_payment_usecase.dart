import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

final verifyPaymentUsecaseProvider = Provider<VerifyPaymentUsecase>(
  (ref) => VerifyPaymentUsecase(ref.read(orderRepositoryProvider)),
);

class VerifyPaymentUsecase implements UsecaseWithParams<OrderEntity, String> {
  final IOrderRepository _repository;

  VerifyPaymentUsecase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String pidx) => _repository.verifyPayment(pidx);
}
