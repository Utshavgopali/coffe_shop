import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/change_password_confirm_usecase.dart';
import '../../domain/usecases/change_password_request_code_usecase.dart';
import '../state/change_password_state.dart';

final changePasswordViewModelProvider =
    NotifierProvider<ChangePasswordViewModel, ChangePasswordState>(
  ChangePasswordViewModel.new,
);

class ChangePasswordViewModel extends Notifier<ChangePasswordState> {
  late ChangePasswordRequestCodeUsecase _requestCodeUsecase;
  late ChangePasswordConfirmUsecase _confirmUsecase;

  @override
  ChangePasswordState build() {
    _requestCodeUsecase = ref.read(changePasswordRequestCodeUsecaseProvider);
    _confirmUsecase = ref.read(changePasswordConfirmUsecaseProvider);
    return const ChangePasswordState();
  }

  Future<void> requestCode(String currentPassword) async {
    state = state.copyWith(
      status: ChangePasswordStatus.submitting,
      errorMessage: null,
      infoMessage: null,
    );

    final result = await _requestCodeUsecase(currentPassword);

    result.fold(
      (failure) => state = state.copyWith(
        status: ChangePasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ChangePasswordStatus.idle,
        step: ChangePasswordStep.code,
        infoMessage: 'A verification code has been sent to your email.',
      ),
    );
  }

  Future<void> confirm(String code, String newPassword) async {
    state = state.copyWith(status: ChangePasswordStatus.submitting, errorMessage: null);

    final result = await _confirmUsecase(
      ChangePasswordConfirmParams(code: code, newPassword: newPassword),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChangePasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ChangePasswordStatus.idle,
        step: ChangePasswordStep.done,
      ),
    );
  }

  void reset() {
    state = const ChangePasswordState();
  }
}
