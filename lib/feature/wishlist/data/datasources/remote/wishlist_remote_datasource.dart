import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/wishlist_api_model.dart';
import '../wishlist_datasource.dart';

final wishlistRemoteDatasourceProvider = Provider<IWishlistRemoteDataSource>(
  (ref) => WishlistRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class WishlistRemoteDatasource implements IWishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDatasource({required this.apiClient});

  @override
  Future<List<WishlistApiModel>> getWishlist() async {
    final response = await apiClient.get(ApiEndpoints.wishlist);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => WishlistApiModel.fromJson(json)).toList();
  }

  @override
  Future<void> addToWishlist(String beanId) async {
    await apiClient.post(ApiEndpoints.wishlistItem(beanId));
  }

  @override
  Future<void> removeFromWishlist(String beanId) async {
    await apiClient.delete(ApiEndpoints.wishlistItem(beanId));
  }
}
