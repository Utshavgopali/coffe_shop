import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bean_entity.dart';
import '../../domain/usecases/get_beans_usecase.dart';

// keyed by limit, so Home (small limit) and any "see all" listing can each
// get their own independently-cached result
final featuredBeansProvider =
    FutureProvider.family<List<BeanEntity>, int>((ref, limit) async {
  final usecase = ref.read(getBeansUsecaseProvider);
  final result = await usecase(
    GetBeansParams(limit: limit, sort: '-createdAt'),
  );

  return result.fold(
    (failure) => throw failure,
    (data) => data.beans,
  );
});
