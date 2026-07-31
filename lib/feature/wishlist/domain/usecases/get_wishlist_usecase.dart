import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../entities/wishlist_entity.dart';
import '../repositories/wishlist_repository.dart';

final getWishlistUsecaseProvider = Provider<GetWishlistUsecase>(
  (ref) => GetWishlistUsecase(ref.read(wishlistRepositoryProvider)),
);

class GetWishlistUsecase implements UsecaseWithoutParams<List<WishlistEntity>> {
  final IWishlistRepository _repository;

  GetWishlistUsecase(this._repository);

  @override
  Future<Either<Failure, List<WishlistEntity>>> call() => _repository.getWishlist();
}
