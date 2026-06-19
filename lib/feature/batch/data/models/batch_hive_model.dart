import 'package:coffeshop_mobile/feature/batch/domain/entities/batch_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'batch_hive_model.g.dart';

@HiveType(typeId: 1)
class BatchHiveModel extends HiveObject {
  @HiveField(0)
  final String? batchId;

  @HiveField(1)
  final String batchName;

  @HiveField(2)
  final String? status;

  BatchHiveModel({
    String? batchId,
    required this.batchName,
    String? status,
  })  : batchId = batchId ?? const Uuid().v4(),
        status = status ?? 'active';

  BatchEntity toEntity() => BatchEntity(
        batchId: batchId,
        batchName: batchName,
        status: status,
      );

  factory BatchHiveModel.fromEntity(BatchEntity entity) => BatchHiveModel(
        batchId: entity.batchId,
        batchName: entity.batchName,
        status: entity.status,
      );

  static List<BatchEntity> toEntityList(List<BatchHiveModel> models) =>
      models.map((m) => m.toEntity()).toList();
}