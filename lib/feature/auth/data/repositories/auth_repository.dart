import 'package:coffeshop_mobile/feature/auth/data/datasources/auth_datasource.dart';
import 'package:coffeshop_mobile/feature/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';
import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:coffeshop_mobile/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource localDataSource;
  final AuthRemoteDatasource remoteDataSource;

  AuthRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<AuthEntity?> login(String email, String password) async {
    // 1. Try remote login
    final remoteUser = await remoteDataSource.login(email, password);
    if (remoteUser != null) {
      // Save to Hive cache
      final hiveModel = AuthHiveModel.fromEntity(remoteUser);
      hiveModel.password = password; // store password for offline fallback
      await localDataSource.saveUser(hiveModel);
      await localDataSource.saveCurrentUserId(remoteUser.id!);
      return remoteUser;
    }

    // 2. Fallback to Hive cache
    final localUser = await localDataSource.getUserByEmail(email);
    if (localUser != null && localUser.password == password) {
      await localDataSource.saveCurrentUserId(localUser.id);
      return localUser.toEntity();
    }

    return null;
  }

  @override
  Future<bool> register(AuthEntity entity) async {
    // 1. Try remote register
    final success = await remoteDataSource.register(entity);
    if (success) {
      // Cache user details locally
      await localDataSource.saveUser(AuthHiveModel.fromEntity(entity));
      return true;
    }

    // 2. Local fallback
    final existing = await localDataSource.getUserByEmail(entity.email);
    if (existing != null) return false;
    await localDataSource.saveUser(AuthHiveModel.fromEntity(entity));
    return true;
  }

  @override
  Future<AuthEntity?> getCurrentUser() async {
    // Try retrieving local current user ID first
    final id = await localDataSource.getCurrentUserId();
    if (id == null) return null;

    // Try fetching from remote to ensure sync
    final remoteUser = await remoteDataSource.getCurrentUser();
    if (remoteUser != null) {
      final hiveModel = AuthHiveModel.fromEntity(remoteUser);
      // Fetch password from existing local cache if there to preserve it
      final cached = await localDataSource.getUserById(id);
      if (cached != null) {
        hiveModel.password = cached.password;
      }
      await localDataSource.saveUser(hiveModel);
      return remoteUser;
    }

    // Fallback to local
    final localUser = await localDataSource.getUserById(id);
    return localUser?.toEntity();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearSession();
  }

  // Helper method for updating user profile and syncing
  Future<AuthEntity?> updateProfile(AuthEntity entity) async {
    final updatedUser = await remoteDataSource.updateProfile(entity);
    if (updatedUser != null) {
      final hiveModel = AuthHiveModel.fromEntity(updatedUser);
      final id = await localDataSource.getCurrentUserId();
      if (id != null) {
        final cached = await localDataSource.getUserById(id);
        if (cached != null) {
          hiveModel.password = cached.password;
        }
      }
      await localDataSource.saveUser(hiveModel);
      return updatedUser;
    }
    return null;
  }
}