import 'package:coffeshop_mobile/app/routes/app_routes.dart';
import 'package:coffeshop_mobile/app/theme/app_theme.dart';
import 'package:coffeshop_mobile/app/theme/brightness_view_model.dart';
import 'package:coffeshop_mobile/app/theme/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoffeeShopApp extends ConsumerWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);
    // Keeps BrightnessViewModel alive for the app's lifetime so its lux
    // subscription (when auto brightness is on) keeps running regardless
    // of which screen is showing — its own state isn't used for layout.
    ref.watch(brightnessViewModelProvider);

    return MaterialApp(
      title: 'Coffee Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeState.themeMode,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
