import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/wishlist_entity.dart';

abstract interface class IWishlistRepository {
  Future<Either<Failure, List<WishlistEntity>>> getWishlist();

  Future<Either<Failure, bool>> addToWishlist(String beanId);

  Future<Either<Failure, bool>> removeFromWishlist(String beanId);
}
