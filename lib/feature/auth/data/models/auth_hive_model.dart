import 'package:hive/hive.dart';

import '../../../../core/constants/hive_table_constant.dart';
import '../../domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  String? avatar;

  @HiveField(4)
  late String role;

  @HiveField(5)
  late String provider;

  AuthHiveModel();

  AuthHiveModel.withData({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role = 'user',
    this.provider = 'local',
  });

  AuthEntity toEntity() => AuthEntity(
        id: id,
        name: name,
        email: email,
        avatar: avatar,
        role: role,
        provider: provider,
      );

  static AuthHiveModel fromEntity(AuthEntity entity) => AuthHiveModel.withData(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        avatar: entity.avatar,
        role: entity.role,
        provider: entity.provider,
      );
}
