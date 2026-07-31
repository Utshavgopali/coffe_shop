import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth/google_auth_service.dart';
import '../../../../core/services/biometric/biometric_service.dart';
import '../../../../core/services/storage/session_service.dart';
import '../../../../core/services/storage/token_service.dart';
import '../../../cart/presentation/view_model/cart_view_model.dart';
import '../../../dashboard/presentation/providers/bottom_nav_provider.dart';
import '../../../notification/presentation/view_model/notification_view_model.dart';
import '../../../wishlist/presentation/view_model/wishlist_view_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late LoginUsecase _loginUsecase;
  late GoogleLoginUsecase _googleLoginUsecase;
  late RegisterUsecase _registerUsecase;
  late LogoutUsecase _logoutUsecase;
  late GetCurrentUserUsecase _getCurrentUserUsecase;
  late UpdateProfileUsecase _updateProfileUsecase;
  late SessionService _sessionService;
  late TokenService _tokenService;
  late BiometricService _biometricService;
  late GoogleAuthService _googleAuthService;

  @override
  AuthState build() {
    _loginUsecase = ref.read(loginUsecaseProvider);
    _googleLoginUsecase = ref.read(googleLoginUsecaseProvider);
    _registerUsecase = ref.read(registerUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _sessionService = ref.read(sessionServiceProvider);
    _tokenService = ref.read(tokenServiceProvider);
    _biometricService = ref.read(biometricServiceProvider);
    _googleAuthService = ref.read(googleAuthServiceProvider);
    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _loginUsecase(
      LoginUsecaseParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );

    if (state.status == AuthStatus.authenticated) {
      ref.read(bottomNavProvider.notifier).state = 0;
      ref.read(cartViewModelProvider.notifier).loadCart();
      await _sessionService.saveLastLoggedInUserId(state.user!.id);
    }
  }

  // A user-cancelled account picker is not a failure — state just goes
  // back to initial with no error banner in that case.
  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final String? idToken;
    try {
      idToken = await _googleAuthService.signIn();
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Google sign-in failed. Please try again.',
      );
      return;
    }

    if (idToken == null) {
      state = state.copyWith(status: AuthStatus.initial);
      return;
    }

    final result = await _googleLoginUsecase(idToken);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );

    if (state.status == AuthStatus.authenticated) {
      ref.read(bottomNavProvider.notifier).state = 0;
      ref.read(cartViewModelProvider.notifier).loadCart();
      await _sessionService.saveLastLoggedInUserId(state.user!.id);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _registerUsecase(
      RegisterUsecaseParams(name: name, email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.registered,
        user: user,
      ),
    );

    if (state.status == AuthStatus.registered) {
      await _sessionService.saveLastLoggedInUserId(state.user!.id);
    }
  }

  Future<void> logout() async {
    await _logoutUsecase();
    await _googleAuthService.signOut();
    ref.read(wishlistViewModelProvider.notifier).clearCache();
    ref.read(cartViewModelProvider.notifier).clearCache();
    ref.read(notificationViewModelProvider.notifier).clearCache();
    state = const AuthState(status: AuthStatus.loggedOut);
  }

  Future<void> checkCurrentUser() async {
    final result = await _getCurrentUserUsecase();
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.loggedOut),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );

    if (state.status == AuthStatus.authenticated) {
      ref.read(cartViewModelProvider.notifier).loadCart();
      await _sessionService.saveLastLoggedInUserId(state.user!.id);
    }
  }

  // Restores a session using the fingerprint token stashed when the user
  // enabled it in Profile — display info comes from the LOCAL Hive cache
  // (not GET /auth/whoami), since at this point there's no active token
  // yet to call it with: that call would just fail with 401. The token
  // itself is restored separately from secure storage below; without
  // that, every real API call after this would 401 since there'd be no
  // Authorization header to send.
  Future<void> loginWithBiometric() async {
    if (!_sessionService.isBiometricLoginEnabled()) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Fingerprint login is not enabled. Enable it from your Profile after logging in normally.',
      );
      return;
    }

    final canUse = await _biometricService.canCheckBiometrics();
    if (!canUse) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Fingerprint is not available or not set up on this device.',
      );
      return;
    }

    final authenticated = await _biometricService.authenticate(
      reason: 'Scan your fingerprint to log in',
    );
    if (!authenticated) {
      // user cancelled or failed the scan — stay on the login screen
      // without showing an error state
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final userId = _sessionService.getBiometricBoundUserId();
    final localDatasource = ref.read(authLocalDatasourceProvider);
    final cachedUser = await localDatasource.getCachedUser();

    if (userId == null || cachedUser == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Could not find your saved account on this device. Please log in with your password.',
      );
      return;
    }

    final biometricToken = await _tokenService.getBiometricToken(userId);
    if (biometricToken == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage:
            'Fingerprint login needs to be re-enabled. Log in with your password, then turn it back on from Profile.',
      );
      return;
    }

    await _tokenService.saveToken(biometricToken);

    state = state.copyWith(status: AuthStatus.authenticated, user: cachedUser.toEntity());
    ref.read(bottomNavProvider.notifier).state = 0;
    ref.read(cartViewModelProvider.notifier).loadCart();
    await _sessionService.saveLastLoggedInUserId(cachedUser.toEntity().id);
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }

  Future<bool> updateProfile({String? name, File? avatarFile}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(name: name, avatarFile: avatarFile),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        return true;
      },
    );
  }
}
