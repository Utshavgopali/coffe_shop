import 'package:coffeshop_mobile/core/constants/hive_table_constant.dart';
import 'package:coffeshop_mobile/feature/auth/data/datasources/auth_datasource.dart';
import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthLocalDatasource implements IAuthDataSource {
  Future<Box<AuthHiveModel>> get _userBox =>
      Hive.openBox<AuthHiveModel>(HiveTableConstant.userBoxName);

  Future<Box> get _sessionBox =>
      Hive.openBox(HiveTableConstant.sessionBoxName);

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    final box = await _userBox;
    try {
      return box.values.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getUserById(String id) async {
    final box = await _userBox;
    return box.get(id);
  }

  @override
  Future<void> saveUser(AuthHiveModel model) async {
    final box = await _userBox;
    await box.put(model.id, model);
  }

  @override
  Future<void> saveCurrentUserId(String id) async {
    final box = await _sessionBox;
    await box.put(HiveTableConstant.currentUserKey, id);
  }

  @override
  Future<String?> getCurrentUserId() async {
    final box = await _sessionBox;
    return box.get(HiveTableConstant.currentUserKey) as String?;
  }

  @override
  Future<void> clearSession() async {
    final box = await _sessionBox;
    await box.delete(HiveTableConstant.currentUserKey);
  }
}