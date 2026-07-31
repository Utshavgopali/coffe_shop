import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../repositories/wishlist_repository.dart';

final removeWishlistUsecaseProvider = Provider<RemoveWishlistUsecase>(
  (ref) => RemoveWishlistUsecase(ref.read(wishlistRepositoryProvider)),
);

class RemoveWishlistUsecase implements UsecaseWithParams<bool, String> {
  final IWishlistRepository _repository;

  RemoveWishlistUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String beanId) => _repository.removeFromWishlist(beanId);
}
