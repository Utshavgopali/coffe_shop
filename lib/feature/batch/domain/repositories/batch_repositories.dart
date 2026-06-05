import 'package:dartz/dartz.dart';
import 'package:coffeshop_mobile/core/error/failures.dart';
import 'package:coffeshop_mobile/feature/batch/domain/entities/batch_entity.dart';

abstract class IBatchRepository {
  Future<Either<Failure, bool>> createBatch(BatchEntity batch);
  Future<Either<Failure, bool>> deleteBatch(String batchId);
  Future<Either<Failure, List<BatchEntity>>> getAllBatches();
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId);
  Future<Either<Failure, bool>> updateBatch(BatchEntity batch);
}