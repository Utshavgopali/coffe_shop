import 'package:coffeshop_mobile/app/app.dart';
import 'package:coffeshop_mobile/core/providers/shared_prefs_provider.dart';
import 'package:coffeshop_mobile/core/services/hive/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const CoffeeShopApp(),
    ),
  );
}
