import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/presentation/view_model/cart_view_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/checkout_usecase.dart';
import '../../domain/usecases/verify_payment_usecase.dart';
import '../providers/orders_list_provider.dart';
import '../state/checkout_state.dart';

final checkoutViewModelProvider =
    NotifierProvider<CheckoutViewModel, CheckoutState>(CheckoutViewModel.new);

class CheckoutViewModel extends Notifier<CheckoutState> {
  late CheckoutUsecase _checkoutUsecase;
  late VerifyPaymentUsecase _verifyPaymentUsecase;

  @override
  CheckoutState build() {
    _checkoutUsecase = ref.read(checkoutUsecaseProvider);
    _verifyPaymentUsecase = ref.read(verifyPaymentUsecaseProvider);
    return const CheckoutState();
  }

  Future<void> startCheckout(ShippingAddressEntity shippingAddress) async {
    state = state.copyWith(status: CheckoutStatus.submittingCheckout, errorMessage: null);

    final result = await _checkoutUsecase(shippingAddress);

    result.fold(
      (failure) => state = state.copyWith(status: CheckoutStatus.failed, errorMessage: failure.message),
      (checkoutResult) => state = state.copyWith(
        status: CheckoutStatus.awaitingPayment,
        paymentUrl: checkoutResult.paymentUrl,
        pidx: checkoutResult.pidx,
        order: checkoutResult.order,
      ),
    );
  }

  Future<void> verifyPayment() async {
    final pidx = state.pidx;
    if (pidx == null) return;

    state = state.copyWith(status: CheckoutStatus.verifying, errorMessage: null);

    final result = await _verifyPaymentUsecase(pidx);

    result.fold(
      (failure) => state = state.copyWith(status: CheckoutStatus.failed, errorMessage: failure.message),
      (order) {
        final paid = order.status == 'paid';
        state = state.copyWith(
          status: paid ? CheckoutStatus.success : CheckoutStatus.failed,
          order: order,
        );

        if (paid) {
          // The backend clears the cart on a successful payment — refresh
          // the client-side cart state and the orders list to match.
          ref.read(cartViewModelProvider.notifier).loadCart();
          ref.invalidate(myOrdersProvider);
        }
      },
    );
  }

  void reset() {
    state = const CheckoutState();
  }
}
