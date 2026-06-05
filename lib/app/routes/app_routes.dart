import 'package:coffeshop_mobile/feature/auth/presentation/pages/login_page.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/pages/signup_page.dart';
import 'package:coffeshop_mobile/feature/dashboard/presentation/pages/dashboard_page.dart';
import 'package:coffeshop_mobile/feature/onboarding/presentation/pages/onboarding_page.dart';
import 'package:coffeshop_mobile/feature/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashPage(),
    onboarding: (_) => const OnboardingPage(),
    login: (_) => const LoginPage(),
    signup: (_) => const SignupPage(),
    dashboard: (_) => const DashboardPage(),
  };
}