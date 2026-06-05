import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffeshop_app/core/error/failures.dart';
import 'package:coffeshop_app/core/services/connectivity/network_info.dart';
import 'package:coffeshop_app/features/batch/data/datasources/batch_datasource.dart';
import 'package:coffeshop_app/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:coffeshop_app/features/batch/data/datasources/remote/batch_remote_datasource.dart';
import 'package:coffeshop_app/features/batch/data/models/batch_api_model.dart';
import 'package:coffeshop_app/features/batch/data/models/batch_hive_model.dart';
import 'package:coffeshop_app/features/batch/domain/entities/batch_entity.dart';
import 'package:coffeshop_app/features/batch/domain/repositories/batch_repository.dart';

// Create provider
final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  final batchLocalDatasource = ref.read(batchLocalDatasourceProvider);
  final batchRemoteDatasource = ref.read(batchRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BatchRepository(
    batchDatasource: batchLocalDatasource,
    batchRemoteDatasource: batchRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class BatchRepository implements IBatchRepository {
  final IBatchLocalDataSource _batchLocalDataSource;
  final IBatchRemoteDataSource _batchRemoteDataSource;
  final NetworkInfo _networkInfo;

  BatchRepository({
    required IBatchLocalDataSource batchDatasource,
    required IBatchRemoteDataSource batchRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _batchLocalDataSource = batchDatasource,
       _batchRemoteDataSource = batchRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity batch) async {
    try {
      // Convert entity to hive model
      final batchModel = BatchHiveModel.fromEntity(batch);
      final result = await _batchLocalDataSource.createBatch(batchModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create a batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String batchId) async {
    try {
      final result = await _batchLocalDataSource.deleteBatch(batchId);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: 'Failed to delete batch'),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getAllBatches() async {
    // Check internet connection
    if (await _networkInfo.isConnected) {
      try {
        // Fetch from remote and convert api models to entities
        final apiModels = await _batchRemoteDataSource.getAllBatches();
        final result = BatchApiModel.toEntityList(apiModels);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to fetch batches',
          ),
        );
      }
    } else {
      try {
        // Fallback to local database
        final models = await _batchLocalDataSource.getAllBatches();
        final entities = BatchHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId) async {
    try {
      final model = await _batchLocalDataSource.getBatchById(batchId);
      if (model != null) {
        return Right(model.toEntity());
      }
      return const Left(
        LocalDatabaseFailure(message: 'Batch not found'),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBatch(BatchEntity batch) async {
    try {
      // Convert entity to hive model
      final batchModel = BatchHiveModel.fromEntity(batch);
      final result = await _batchLocalDataSource.updateBatch(batchModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}