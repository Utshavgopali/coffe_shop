import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<AuthEntity?> login(String email, String password);
  Future<bool> register(AuthEntity entity);
  Future<AuthEntity?> getCurrentUser();
  Future<void> logout();
}