import 'package:equatable/equatable.dart';

enum ForgotPasswordStep { email, code, newPassword, done }

enum ForgotPasswordStatus { idle, submitting, error }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStep step;
  final ForgotPasswordStatus status;
  final String email;
  final String code;
  final String? infoMessage;
  final String? errorMessage;

  const ForgotPasswordState({
    this.step = ForgotPasswordStep.email,
    this.status = ForgotPasswordStatus.idle,
    this.email = '',
    this.code = '',
    this.infoMessage,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    ForgotPasswordStatus? status,
    String? email,
    String? code,
    String? infoMessage,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      email: email ?? this.email,
      code: code ?? this.code,
      infoMessage: infoMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [step, status, email, code, infoMessage, errorMessage];
}
