import 'package:coffeshop_mobile/core/services/hive/hive_service.dart';
import 'package:coffeshop_mobile/feature/batch/data/datasources/batch_datasource.dart';
import 'package:coffeshop_mobile/feature/batch/data/models/batch_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final batchLocalDatasourceProvider = Provider<BatchLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return BatchLocalDatasource(hiveService: hiveService);
});

class BatchLocalDatasource implements IBatchLocalDataSource {
  final HiveService _hiveService;

  BatchLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<bool> createBatch(BatchHiveModel batch) async {
    try {
      await _hiveService.createBatch(batch);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteBatch(String batchId) async {
    try {
      await _hiveService.deleteBatch(batchId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BatchHiveModel>> getAllBatches() async {
    try {
      return await _hiveService.getAllBatches();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BatchHiveModel?> getBatchById(String batchId) async {
    try {
      return await _hiveService.getBatchById(batchId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateBatch(BatchHiveModel batch) async {
    try {
      await _hiveService.updateBatch(batch);
      return true;
    } catch (e) {
      return false;
    }
  }
}