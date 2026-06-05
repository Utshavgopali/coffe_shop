import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:coffeshop_mobile/feature/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final IAuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<AuthEntity?> call() => repository.getCurrentUser();
}