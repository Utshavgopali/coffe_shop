import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../state/checkout_state.dart';
import '../view_model/checkout_view_model.dart';
import 'order_detail_page.dart';
import 'orders_list_page.dart';

class OrderConfirmationPage extends ConsumerWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutViewModelProvider);
    final isSuccess = state.status == CheckoutStatus.success;
    final order = state.order;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: (isSuccess ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                  size: 56,
                  color: isSuccess ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isSuccess
                    ? AppStrings.get('paymentSuccessful', lang)
                    : AppStrings.get('paymentNotCompleted', lang),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSuccess
                    ? AppStrings.get('orderPlacedBeingPrepared', lang)
                    : state.errorMessage ?? AppStrings.get('paymentCancelledOrFailed', lang),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextSecondary),
              ),
              const SizedBox(height: 32),
              if (isSuccess && order != null)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(checkoutViewModelProvider.notifier).reset();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.id)),
                        (route) => route.isFirst,
                      );
                    },
                    child: Text(AppStrings.get('viewOrder', lang)),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(checkoutViewModelProvider.notifier).reset();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text(AppStrings.get('backToShop', lang)),
                  ),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  ref.read(checkoutViewModelProvider.notifier).reset();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersListPage()),
                    (route) => route.isFirst,
                  );
                },
                child: Text(AppStrings.get('myOrders', lang), style: const TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
