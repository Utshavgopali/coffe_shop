import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bean_entity.dart';
import '../../domain/usecases/get_bean_by_id_usecase.dart';

final beanDetailProvider = FutureProvider.family<BeanEntity, String>((ref, beanId) async {
  final usecase = ref.read(getBeanByIdUsecaseProvider);
  final result = await usecase(beanId);

  return result.fold(
    (failure) => throw failure,
    (bean) => bean,
  );
});
