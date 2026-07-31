import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/bean_api_model.dart';
import '../bean_datasource.dart';

final beanRemoteDatasourceProvider = Provider<IBeanRemoteDataSource>(
  (ref) => BeanRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class BeanRemoteDatasource implements IBeanRemoteDataSource {
  final ApiClient apiClient;

  BeanRemoteDatasource({required this.apiClient});

  @override
  Future<BeanRemoteListResult> getBeans({
    required int page,
    required int limit,
    required String search,
    required String category,
    required List<String> roastLevel,
    required List<String> origin,
    double? minPrice,
    double? maxPrice,
    bool? featured,
    required String sort,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.beans,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search.isNotEmpty) 'search': search,
        if (category.isNotEmpty) 'category': category,
        if (roastLevel.isNotEmpty) 'roastLevel': roastLevel.join(','),
        if (origin.isNotEmpty) 'origin': origin.join(','),
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (featured != null) 'featured': featured.toString(),
        if (sort.isNotEmpty) 'sort': sort,
      },
    );

    final List<dynamic> data = response.data['data'] ?? [];
    final meta = response.data['meta'];

    return BeanRemoteListResult(
      beans: data.map((json) => BeanApiModel.fromJson(json)).toList(),
      page: meta?['page'] ?? page,
      limit: meta?['limit'] ?? limit,
      total: meta?['total'] ?? data.length,
      totalPages: meta?['totalPages'] ?? 1,
    );
  }

  @override
  Future<BeanApiModel> getBeanById(String id) async {
    final response = await apiClient.get(ApiEndpoints.beanById(id));
    return BeanApiModel.fromJson(response.data['data']);
  }

  @override
  Future<Map<String, Map<String, int>>> getFacets({String? category}) async {
    final response = await apiClient.get(
      ApiEndpoints.beanFacets,
      queryParameters: {if (category != null && category.isNotEmpty) 'category': category},
    );

    final Map<String, dynamic> data = response.data['data'] ?? {};
    return data.map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toInt()),
        ),
      ),
    );
  }
}
