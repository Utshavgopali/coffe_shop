import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/orders_list_provider.dart';
import 'order_detail_page.dart';

class OrdersListPage extends ConsumerWidget {
  const OrdersListPage({super.key});

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
    final ordersAsync = ref.watch(myOrdersProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('myOrders', lang),
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, color: AppColors.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(myOrdersProvider),
        child: ordersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => ListView(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Montserrat'),
                ),
              ),
            ],
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      AppStrings.get('noOrdersYet', lang),
                      style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderTile(
                  order: order,
                  statusColor: _statusColor(order.status),
                  statusLabel: _statusLabel(order.status, lang),
                  lang: lang,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.id)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderEntity order;
  final Color statusColor;
  final String statusLabel;
  final AppLanguage lang;
  final VoidCallback onTap;

  const _OrderTile({
    required this.order,
    required this.statusColor,
    required this.statusLabel,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = order.items.fold<int>(0, (sum, i) => sum + i.quantity);
    final itemWord = AppStrings.get(itemCount == 1 ? 'item' : 'items', lang);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.get('orderNumberPrefix', lang)}${order.id.substring(order.id.length - 6).toUpperCase()}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$itemCount $itemWord · Rs. ${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: context.appTextSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
