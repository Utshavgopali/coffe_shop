import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

enum CheckoutStatus { idle, submittingCheckout, awaitingPayment, verifying, success, failed }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final String? paymentUrl;
  final String? pidx;
  final OrderEntity? order;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.paymentUrl,
    this.pidx,
    this.order,
    this.errorMessage,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? paymentUrl,
    String? pidx,
    OrderEntity? order,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      pidx: pidx ?? this.pidx,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, paymentUrl, pidx, order, errorMessage];
}
