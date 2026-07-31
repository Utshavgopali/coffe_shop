import 'package:coffeshop_mobile/app/locale/app_strings.dart';
import 'package:coffeshop_mobile/app/locale/locale_view_model.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/state/auth_state.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Auth state is shared app-wide, so a stale error from a previous
    // failed login (or an earlier signup attempt) would otherwise still
    // be showing here even though the user hasn't submitted anything yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authViewModelProvider.notifier).register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('accountCreatedPleaseLogin', ref.read(localeViewModelProvider).language)),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context);
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(AppStrings.get('createAccount', lang)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('joinCoffeeShop', lang),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.get('createAccountSubtitle', lang),
                  style: TextStyle(
                    color: context.appTextSecondary,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 28),

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

                _buildField(
                  controller: _nameCtrl,
                  label: AppStrings.get('fullName', lang),
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? AppStrings.get('nameIsRequired', lang) : null,
                ),
                const SizedBox(height: 14),
                _buildField(
                  controller: _emailCtrl,
                  label: AppStrings.get('email', lang),
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (authState.errorMessage != null) {
                      ref
                          .read(authViewModelProvider.notifier)
                          .clearError();
                    }
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppStrings.get('emailIsRequired', lang);
                    if (!v.contains('@')) return AppStrings.get('enterAValidEmail', lang);
                    return null;
                  },
                ),
                const SizedBox(height: 14),

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
                const SizedBox(height: 14),

                // Confirm password
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: AppStrings.get('confirmPassword', lang),
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppColors.primary),
                  ),
                  validator: (v) {
                    if (v != _passwordCtrl.text) {
                      return AppStrings.get('passwordsDoNotMatch', lang);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Register button
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
                            AppStrings.get('createAccountButton', lang),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.get('alreadyHaveAccount', lang),
                      style: TextStyle(color: context.appTextSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        // Login isn't rebuilt from scratch on pop (it's the
                        // same still-mounted instance) so its own initState
                        // won't rerun to clear this — a failed signup's
                        // error would otherwise reappear on the login
                        // screen underneath.
                        ref.read(authViewModelProvider.notifier).clearError();
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppStrings.get('login', lang),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
      validator: validator,
    );
  }
}