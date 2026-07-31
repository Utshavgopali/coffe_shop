import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../dashboard/presentation/providers/bottom_nav_provider.dart';
import '../../../order/presentation/pages/checkout_page.dart';
import '../../domain/entities/cart_entity.dart';
import '../state/cart_state.dart';
import '../view_model/cart_view_model.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartViewModelProvider.notifier).loadCart());
  }

  Future<void> _confirmClearCart() async {
    final lang = ref.read(localeViewModelProvider).language;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.get('clearCart', lang)),
        content: Text(AppStrings.get('clearCartConfirm', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.get('cancel', lang)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppStrings.get('clearCart', lang),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(cartViewModelProvider.notifier).clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('yourCart', lang),
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, color: AppColors.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (state.cart.items.isNotEmpty)
            TextButton(
              onPressed: _confirmClearCart,
              child: Text(
                AppStrings.get('clearCart', lang),
                style: const TextStyle(fontFamily: 'Montserrat', color: AppColors.error, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      // Deliberately not using Scaffold.bottomNavigationBar or wrapping the
      // list in RefreshIndicator here: that combination reliably produced a
      // broken layout on this device's Impeller/Vulkan renderer (order
      // summary rendered detached from the bottom of the screen, item list
      // invisible despite correct state). Keeping everything inside a
      // single Column in the body sidesteps it.
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildList(state, lang)),
            if (state.cart.items.isNotEmpty) _buildSummary(context, state.cart, lang),
          ],
        ),
      ),
    );
  }

  Widget _buildList(CartState state, AppLanguage lang) {
    if (state.status == CartStatus.loading && state.cart.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.status == CartStatus.error && state.cart.items.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              state.errorMessage ?? AppStrings.get('somethingWentWrong', lang),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () => ref.read(cartViewModelProvider.notifier).loadCart(),
              child: Text(AppStrings.get('retry', lang)),
            ),
          ),
        ],
      );
    }

    if (state.cart.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.shopping_bag_outlined, size: 40, color: context.appTextSecondary),
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.get('yourCartIsEmpty', lang),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.get('yourCartIsEmptySubtitle', lang),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(bottomNavProvider.notifier).state = 0;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                  ),
                  child: Text(AppStrings.get('browseBeans', lang)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: state.cart.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _CartItemTile(item: state.cart.items[index]),
    );
  }

  Widget _buildSummary(BuildContext context, CartEntity cart, AppLanguage lang) {
    final itemWord = AppStrings.get(cart.totalItems == 1 ? 'item' : 'items', lang);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.get('subtotal', lang)} · ${cart.totalItems} $itemWord',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextSecondary),
              ),
              Text(
                'Rs. ${cart.totalPrice.toStringAsFixed(0)}',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get('total', lang),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
              ),
              Text(
                'Rs. ${cart.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckoutPage()),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                AppStrings.get('checkout', lang),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartItemEntity item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bean = item.bean;
    final imageUrl = bean.images.isNotEmpty ? ApiEndpoints.resolveImageUrl(bean.images.first) : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _placeholder(),
                    errorWidget: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bean.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rs. ${bean.price.toStringAsFixed(0)} ${AppStrings.get('each', ref.read(localeViewModelProvider).language)}',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: context.appTextSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () => ref
                          .read(cartViewModelProvider.notifier)
                          .updateQuantity(bean.id, item.quantity - 1),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: context.appTextPrimary),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: () => ref
                          .read(cartViewModelProvider.notifier)
                          .updateQuantity(bean.id, item.quantity + 1),
                    ),
                    const Spacer(),
                    Text(
                      'Rs. ${item.subtotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: const Icon(Icons.close, size: 18, color: AppColors.error),
            onPressed: () => ref.read(cartViewModelProvider.notifier).removeItem(bean.id),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 68,
      height: 68,
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Icon(Icons.coffee, size: 26, color: AppColors.primary),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}
