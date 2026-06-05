import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:coffeshop_mobile/feature/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthEntity?> call(String email, String password) =>
      repository.login(email, password);
}