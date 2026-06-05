import 'package:coffeshop_mobile/feature/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:coffeshop_mobile/feature/auth/data/repositories/auth_repository.dart';
import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:coffeshop_mobile/feature/auth/domain/usecases/get_current_usecase.dart';
import 'package:coffeshop_mobile/feature/auth/domain/usecases/login_usercase.dart';
import 'package:coffeshop_mobile/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:coffeshop_mobile/feature/auth/domain/usecases/register_usecase.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
final authDatasourceProvider = Provider<AuthLocalDatasource>(
  (ref) => AuthLocalDatasource(),
);

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(ref.watch(authDatasourceProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
  ),
);

// ViewModel
class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final user = await loginUseCase(email, password);
    if (user != null) {
      state = state.copyWith(status: AuthStatus.success, user: user);
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid email or password',
      );
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final entity = AuthEntity(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
    final success = await registerUseCase(entity);
    if (success) {
      state = state.copyWith(status: AuthStatus.success);
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Email is already registered',
      );
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    state = const AuthState(status: AuthStatus.loggedOut);
  }

  Future<void> checkCurrentUser() async {
    final user = await getCurrentUserUseCase();
    if (user != null) {
      state = state.copyWith(status: AuthStatus.success, user: user);
    }
  }

  void clearError() {
    state = state.copyWith(
      status: AuthStatus.initial,
      errorMessage: null,
    );
  }
}