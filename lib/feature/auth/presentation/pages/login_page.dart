import 'package:coffeshop_mobile/app/locale/app_strings.dart';
import 'package:coffeshop_mobile/app/locale/locale_view_model.dart';
import 'package:coffeshop_mobile/app/routes/app_routes.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/core/services/biometric/biometric_service.dart';
import 'package:coffeshop_mobile/core/services/storage/session_service.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/pages/forgot_password_page.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/pages/signup_page.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/state/auth_state.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _showBiometricButton = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final session = ref.read(sessionServiceProvider);
    if (!session.isBiometricLoginEnabled()) return;

    final canUse = await ref.read(biometricServiceProvider).canCheckBiometrics();
    if (mounted) {
      setState(() => _showBiometricButton = canUse);
    }
  }

  Future<void> _loginWithBiometric() async {
    await ref.read(authViewModelProvider.notifier).loginWithBiometric();
  }

  Future<void> _loginWithGoogle() async {
    await ref.read(authViewModelProvider.notifier).loginWithGoogle();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authViewModelProvider.notifier)
        .login(_emailCtrl.text.trim(), _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/images/logo_mark.png',
                    height: 88,
                    width: 88,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.coffee,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Coffee Shop',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    AppStrings.get('welcomeBackSignIn', lang),
                    style: TextStyle(
                      color: context.appTextSecondary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Error message
                if (authState.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (authState.errorMessage != null) {
                      ref
                          .read(authViewModelProvider.notifier)
                          .clearError();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: AppStrings.get('email', lang),
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: AppColors.primary),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppStrings.get('emailIsRequired', lang);
                    if (!v.contains('@')) return AppStrings.get('enterAValidEmail', lang);
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: AppStrings.get('password', lang),
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: context.appTextSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppStrings.get('passwordIsRequired', lang);
                    if (v.length < 6) return AppStrings.get('minimum6Characters', lang);
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                    ),
                    child: Text(
                      AppStrings.get('forgotPassword', lang),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            AppStrings.get('login', lang),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                  ),
                ),

                if (_showBiometricButton) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : _loginWithBiometric,
                      icon: const Icon(Icons.fingerprint, color: AppColors.primary),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: Text(
                        AppStrings.get('loginWithFingerprint', lang),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: context.appBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        AppStrings.get('orContinueWith', lang),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.appTextSecondary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: context.appBorder)),
                  ],
                ),
                const SizedBox(height: 20),

                // Google sign-in
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : _loginWithGoogle,
                    icon: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.appSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.appBorder),
                      ),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.appBorder, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      AppStrings.get('continueWithGoogle', lang),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: context.appTextPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.get('dontHaveAccount', lang),
                      style: TextStyle(color: context.appTextSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignupPage()),
                      ),
                      child: Text(
                        AppStrings.get('signUp', lang),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}