import 'package:coffeshop_mobile/app/routes/app_routes.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    await ref.read(authViewModelProvider.notifier).checkCurrentUser();
    if (!mounted) return;
    final state = ref.read(authViewModelProvider);
    if (state.user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.coffee,
                size: 100,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Coffee Shop',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Premium Coffee Beans',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.white),
          ],
        ),
      ),
    );
  }
}