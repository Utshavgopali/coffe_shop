import 'package:equatable/equatable.dart';

enum ChangePasswordStep { currentPassword, code, done }

enum ChangePasswordStatus { idle, submitting, error }

class ChangePasswordState extends Equatable {
  final ChangePasswordStep step;
  final ChangePasswordStatus status;
  final String? infoMessage;
  final String? errorMessage;

  const ChangePasswordState({
    this.step = ChangePasswordStep.currentPassword,
    this.status = ChangePasswordStatus.idle,
    this.infoMessage,
    this.errorMessage,
  });

  ChangePasswordState copyWith({
    ChangePasswordStep? step,
    ChangePasswordStatus? status,
    String? infoMessage,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      infoMessage: infoMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [step, status, infoMessage, errorMessage];
}
