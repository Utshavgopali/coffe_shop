import 'package:coffeshop_mobile/core/api/api_client.dart';
import 'package:coffeshop_mobile/core/api/api_endpoints.dart';
import 'package:coffeshop_mobile/feature/batch/data/datasources/batch_datasource.dart';
import 'package:coffeshop_mobile/feature/batch/data/models/batch_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final batchRemoteDataSourceProvider =
    Provider<IBatchRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BatchRemoteDatasource(apiClient: apiClient);
});

class BatchRemoteDatasource implements IBatchRemoteDataSource {
  final ApiClient _apiClient;

  BatchRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<bool> createBatch(BatchApiModel batch) async {
    final response = await _apiClient.post(
      ApiEndpoints.batches,
      data: batch.toJson(),
    );
    return response.data['success'] == true;
  }

  @override
  Future<List<BatchApiModel>> getAllBatches() async {
    final response = await _apiClient.get(ApiEndpoints.batches);
    final data = response.data['data'] as List;
    return data
        .map((json) => BatchApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BatchApiModel?> getBatchById(String batchId) async {
    final response =
        await _apiClient.get(ApiEndpoints.batchById(batchId));
    return BatchApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<bool> updateBatch(BatchApiModel batch) async {
    final response = await _apiClient.put(
      ApiEndpoints.batchById(batch.id!),
      data: batch.toJson(),
    );
    return response.data['success'] == true;
  }
}