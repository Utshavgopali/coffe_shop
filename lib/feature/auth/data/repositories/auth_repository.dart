import 'package:coffeshop_mobile/feature/auth/data/datasources/auth_datasource.dart';
import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';
import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:coffeshop_mobile/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource dataSource;
  AuthRepositoryImpl(this.dataSource);

  @override
  Future<AuthEntity?> login(String email, String password) async {
    final user = await dataSource.getUserByEmail(email);
    if (user == null || user.password != password) return null;
    await dataSource.saveCurrentUserId(user.id);
    return user.toEntity();
  }

  @override
  Future<bool> register(AuthEntity entity) async {
    final existing = await dataSource.getUserByEmail(entity.email);
    if (existing != null) return false;
    await dataSource.saveUser(AuthHiveModel.fromEntity(entity));
    return true;
  }

  @override
  Future<AuthEntity?> getCurrentUser() async {
    final id = await dataSource.getCurrentUserId();
    if (id == null) return null;
    final user = await dataSource.getUserById(id);
    return user?.toEntity();
  }

  @override
  Future<void> logout() => dataSource.clearSession();
}