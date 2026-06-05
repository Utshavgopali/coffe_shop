import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:coffeshop_mobile/feature/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository repository;
  RegisterUseCase(this.repository);

  Future<bool> call(AuthEntity entity) => repository.register(entity);
}