import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';

final _orderDetailProvider = FutureProvider.family<OrderEntity, String>((ref, orderId) async {
  final usecase = ref.read(getOrderByIdUsecaseProvider);
  final result = await usecase(orderId);

  return result.fold(
    (failure) => throw failure,
    (order) => order,
  );
});

class OrderDetailPage extends ConsumerWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.success;
      case 'failed':
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  String _statusLabel(String status, AppLanguage lang) {
    switch (status) {
      case 'pending':
        return AppStrings.get('statusPending', lang);
      case 'paid':
        return AppStrings.get('statusPaid', lang);
      case 'failed':
        return AppStrings.get('statusFailed', lang);
      case 'cancelled':
        return AppStrings.get('statusCancelled', lang);
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(_orderDetailProvider(orderId));
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('orderDetails', lang),
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, color: AppColors.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, _) => Center(
          child: Text(error.toString(), style: const TextStyle(fontFamily: 'Montserrat')),
        ),
        data: (order) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.get('orderNumberPrefix', lang)}${order.id.substring(order.id.length - 6).toUpperCase()}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(order.status, lang),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(order.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.get('itemsHeader', lang),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: context.appSurface, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: context.appTextPrimary,
                              ),
                            ),
                            Text(
                              '${item.weightGrams}g × ${item.quantity}',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: context.appTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rs. ${(item.price * item.quantity).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: context.appTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.get('total', lang),
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: context.appTextPrimary),
                  ),
                  Text(
                    'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.get('shippingAddress', lang),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: context.appSurface, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shippingAddress.fullName,
                      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: context.appTextPrimary),
                    ),
                    Text(order.shippingAddress.phone, style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary)),
                    Text(
                      '${order.shippingAddress.street}, ${order.shippingAddress.city}',
                      style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
