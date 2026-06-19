import 'package:coffeshop_mobile/core/constants/hive_table_constant.dart';
import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String fullName;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String password;

  @HiveField(4)
  String? phone;

  @HiveField(5)
  String? profilePicture;

  AuthHiveModel();

  AuthHiveModel.withData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
    this.profilePicture,
  });

  AuthEntity toEntity() => AuthEntity(
        id: id,
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        profilePicture: profilePicture,
      );

  static AuthHiveModel fromEntity(AuthEntity entity) =>
      AuthHiveModel.withData(
        id: entity.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: entity.fullName,
        email: entity.email,
        password: entity.password,
        phone: entity.phone,
        profilePicture: entity.profilePicture,
      );
}