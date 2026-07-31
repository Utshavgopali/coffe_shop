import '../models/wishlist_api_model.dart';

abstract interface class IWishlistRemoteDataSource {
  Future<List<WishlistApiModel>> getWishlist();

  Future<void> addToWishlist(String beanId);

  Future<void> removeFromWishlist(String beanId);
}
