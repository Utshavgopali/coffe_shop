import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';

abstract class IAuthDataSource {
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<AuthHiveModel?> getUserById(String id);
  Future<void> saveUser(AuthHiveModel model);
  Future<void> saveCurrentUserId(String id);
  Future<String?> getCurrentUserId();
  Future<void> clearSession();
}