import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';
import 'package:coffeshop_mobile/feature/batch/data/models/batch_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  static const String _batchBoxName = 'batches';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(BatchHiveModelAdapter());
  }

  // ─── Batch CRUD ────────────────────────────────────────────────────────────

  Future<void> createBatch(BatchHiveModel batch) async {
    final box = await Hive.openBox<BatchHiveModel>(_batchBoxName);
    await box.put(batch.batchId, batch);
  }

  Future<void> deleteBatch(String batchId) async {
    final box = await Hive.openBox<BatchHiveModel>(_batchBoxName);
    await box.delete(batchId);
  }

  Future<List<BatchHiveModel>> getAllBatches() async {
    final box = await Hive.openBox<BatchHiveModel>(_batchBoxName);
    return box.values.toList();
  }

  Future<BatchHiveModel?> getBatchById(String batchId) async {
    final box = await Hive.openBox<BatchHiveModel>(_batchBoxName);
    return box.get(batchId);
  }

  Future<void> updateBatch(BatchHiveModel batch) async {
    final box = await Hive.openBox<BatchHiveModel>(_batchBoxName);
    await box.put(batch.batchId, batch);
  }
}