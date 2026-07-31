import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/forgot_password_request_usecase.dart';
import '../../domain/usecases/forgot_password_reset_usecase.dart';
import '../../domain/usecases/forgot_password_verify_usecase.dart';
import '../state/forgot_password_state.dart';

final forgotPasswordViewModelProvider =
    NotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
  ForgotPasswordViewModel.new,
);

class ForgotPasswordViewModel extends Notifier<ForgotPasswordState> {
  late ForgotPasswordRequestUsecase _requestUsecase;
  late ForgotPasswordVerifyUsecase _verifyUsecase;
  late ForgotPasswordResetUsecase _resetUsecase;

  @override
  ForgotPasswordState build() {
    _requestUsecase = ref.read(forgotPasswordRequestUsecaseProvider);
    _verifyUsecase = ref.read(forgotPasswordVerifyUsecaseProvider);
    _resetUsecase = ref.read(forgotPasswordResetUsecaseProvider);
    return const ForgotPasswordState();
  }

  Future<void> requestCode(String email) async {
    state = state.copyWith(
      status: ForgotPasswordStatus.submitting,
      errorMessage: null,
      infoMessage: null,
    );

    final result = await _requestUsecase(email);

    result.fold(
      (failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.idle,
        step: ForgotPasswordStep.code,
        email: email,
        infoMessage: 'A verification code has been sent to $email.',
      ),
    );
  }

  Future<void> resendCode() async {
    if (state.email.isEmpty) return;

    state = state.copyWith(status: ForgotPasswordStatus.submitting, errorMessage: null);

    final result = await _requestUsecase(state.email);

    result.fold(
      (failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.idle,
        infoMessage: 'A new code has been sent to ${state.email}.',
      ),
    );
  }

  Future<void> verifyCode(String code) async {
    state = state.copyWith(
      status: ForgotPasswordStatus.submitting,
      errorMessage: null,
      infoMessage: null,
    );

    final result = await _verifyUsecase(
      ForgotPasswordVerifyParams(email: state.email, code: code),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.idle,
        step: ForgotPasswordStep.newPassword,
        code: code,
      ),
    );
  }

  Future<void> resetPassword(String newPassword) async {
    state = state.copyWith(status: ForgotPasswordStatus.submitting, errorMessage: null);

    final result = await _resetUsecase(
      ForgotPasswordResetParams(email: state.email, code: state.code, newPassword: newPassword),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.idle,
        step: ForgotPasswordStep.done,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(status: ForgotPasswordStatus.idle, errorMessage: null);
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}
