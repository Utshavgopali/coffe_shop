import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_my_orders_usecase.dart';

final myOrdersProvider = FutureProvider<List<OrderEntity>>((ref) async {
  final usecase = ref.read(getMyOrdersUsecaseProvider);
  final result = await usecase();

  return result.fold(
    (failure) => throw failure,
    (orders) => orders,
  );
});
