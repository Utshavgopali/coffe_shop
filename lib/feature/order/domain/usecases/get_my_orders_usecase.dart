import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

final getMyOrdersUsecaseProvider = Provider<GetMyOrdersUsecase>(
  (ref) => GetMyOrdersUsecase(ref.read(orderRepositoryProvider)),
);

class GetMyOrdersUsecase implements UsecaseWithoutParams<List<OrderEntity>> {
  final IOrderRepository _repository;

  GetMyOrdersUsecase(this._repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call() => _repository.getMyOrders();
}
