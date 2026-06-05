import 'package:coffeshop_mobile/app/routes/app_routes.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryDark),
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.fullName ?? 'Coffee Lover'}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore our premium coffee beans.',
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}