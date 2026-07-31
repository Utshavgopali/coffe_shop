import '../models/auth_hive_model.dart';

abstract class IAuthDataSource {
  Future<void> saveUser(AuthHiveModel model);
  Future<AuthHiveModel?> getCachedUser();
  Future<void> clearSession();
}
