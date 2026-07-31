import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

final getOrderByIdUsecaseProvider = Provider<GetOrderByIdUsecase>(
  (ref) => GetOrderByIdUsecase(ref.read(orderRepositoryProvider)),
);

class GetOrderByIdUsecase implements UsecaseWithParams<OrderEntity, String> {
  final IOrderRepository _repository;

  GetOrderByIdUsecase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String id) => _repository.getOrderById(id);
}
