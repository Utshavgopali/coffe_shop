import 'package:coffeshop_mobile/app/locale/app_strings.dart';
import 'package:coffeshop_mobile/app/locale/locale_view_model.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/feature/cart/presentation/pages/cart_page.dart';
import 'package:coffeshop_mobile/feature/cart/presentation/view_model/cart_view_model.dart';
import 'package:coffeshop_mobile/feature/dashboard/presentation/pages/home_screen.dart';
import 'package:coffeshop_mobile/feature/dashboard/presentation/pages/profile_screen.dart';
import 'package:coffeshop_mobile/feature/dashboard/presentation/pages/search_page.dart';
import 'package:coffeshop_mobile/feature/dashboard/presentation/providers/bottom_nav_provider.dart';
import 'package:coffeshop_mobile/feature/wishlist/presentation/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  static const _screens = [
    HomeScreen(),
    ExploreScreen(),
    WishlistPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);
    final cartCount = ref.watch(cartViewModelProvider).itemCount;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: _screens,
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  if (cartCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                        child: Text(
                          '$cartCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(index: 0, icon: Icons.coffee_rounded, label: AppStrings.get('navBeans', lang)),
                _NavItem(index: 1, icon: Icons.explore_rounded, label: AppStrings.get('navExplore', lang)),
                _NavItem(index: 2, icon: Icons.favorite_rounded, label: AppStrings.get('navWishlist', lang)),
                _NavItem(index: 3, icon: Icons.person_rounded, label: AppStrings.get('navProfile', lang)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final int index;
  final IconData icon;
  final String label;

  const _NavItem({required this.index, required this.icon, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);
    final isSelected = currentIndex == index;
    const activeColor = AppColors.primary;
    final inactiveColor = context.appTextSecondary;

    return GestureDetector(
      onTap: () => ref.read(bottomNavProvider.notifier).state = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? activeColor : inactiveColor, size: 22),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
