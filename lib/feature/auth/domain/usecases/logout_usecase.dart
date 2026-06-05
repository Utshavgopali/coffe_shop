import 'package:coffeshop_mobile/feature/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}