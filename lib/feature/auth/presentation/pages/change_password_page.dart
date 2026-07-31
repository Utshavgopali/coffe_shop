import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../state/change_password_state.dart';
import '../view_model/change_password_view_model.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _currentFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();

  final _currentPasswordCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _codeCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    ref.read(changePasswordViewModelProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordViewModelProvider);
    final isSubmitting = state.status == ChangePasswordStatus.submitting;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('changePassword', lang),
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, color: AppColors.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.infoMessage != null)
                _Banner(text: state.infoMessage!, color: AppColors.success),
              if (state.errorMessage != null)
                _Banner(text: state.errorMessage!, color: AppColors.error),
              switch (state.step) {
                ChangePasswordStep.currentPassword => _CurrentPasswordStep(
                    formKey: _currentFormKey,
                    controller: _currentPasswordCtrl,
                    obscure: _obscure,
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                    isSubmitting: isSubmitting,
                    lang: lang,
                    onSubmit: () {
                      if (!_currentFormKey.currentState!.validate()) return;
                      ref
                          .read(changePasswordViewModelProvider.notifier)
                          .requestCode(_currentPasswordCtrl.text);
                    },
                  ),
                ChangePasswordStep.code => _CodeAndNewPasswordStep(
                    formKey: _codeFormKey,
                    codeCtrl: _codeCtrl,
                    passwordCtrl: _newPasswordCtrl,
                    confirmCtrl: _confirmPasswordCtrl,
                    obscure: _obscure,
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                    isSubmitting: isSubmitting,
                    lang: lang,
                    onSubmit: () {
                      if (!_codeFormKey.currentState!.validate()) return;
                      ref.read(changePasswordViewModelProvider.notifier).confirm(
                            _codeCtrl.text.trim(),
                            _newPasswordCtrl.text,
                          );
                    },
                  ),
                ChangePasswordStep.done => _DoneStep(
                    lang: lang,
                    onDone: () => Navigator.pop(context),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  final Color color;

  const _Banner({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontFamily: 'Montserrat', color: color, fontSize: 13)),
    );
  }
}

class _CurrentPasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final bool isSubmitting;
  final AppLanguage lang;
  final VoidCallback onSubmit;

  const _CurrentPasswordStep({
    required this.formKey,
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
    required this.isSubmitting,
    required this.lang,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('confirmYourCurrentPassword', lang),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.get('sendCodeOnceConfirmed', lang),
            style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: AppStrings.get('currentPassword', lang),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: context.appTextSecondary,
                ),
                onPressed: onToggleObscure,
              ),
            ),
            validator: (v) => (v == null || v.isEmpty) ? AppStrings.get('currentPasswordIsRequired', lang) : null,
          ),
          const SizedBox(height: 24),
          _SubmitButton(label: AppStrings.get('sendCode', lang), isSubmitting: isSubmitting, onPressed: onSubmit),
        ],
      ),
    );
  }
}

class _CodeAndNewPasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final bool isSubmitting;
  final AppLanguage lang;
  final VoidCallback onSubmit;

  const _CodeAndNewPasswordStep({
    required this.formKey,
    required this.codeCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.isSubmitting,
    required this.lang,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('enterCodeAndNewPassword', lang),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: codeCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(counterText: '', hintText: '••••••'),
            validator: (v) {
              if (v == null || v.length != 6) return AppStrings.get('enter6DigitCode', lang);
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: passwordCtrl,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: AppStrings.get('newPassword', lang),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: context.appTextSecondary,
                ),
                onPressed: onToggleObscure,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return AppStrings.get('passwordIsRequired', lang);
              if (v.length < 6) return AppStrings.get('minimum6Characters', lang);
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: confirmCtrl,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: AppStrings.get('confirmNewPassword', lang),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            ),
            validator: (v) {
              if (v != passwordCtrl.text) return AppStrings.get('passwordsDoNotMatch', lang);
              return null;
            },
          ),
          const SizedBox(height: 24),
          _SubmitButton(label: AppStrings.get('updatePassword', lang), isSubmitting: isSubmitting, onPressed: onSubmit),
        ],
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  final AppLanguage lang;
  final VoidCallback onDone;

  const _DoneStep({required this.lang, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.get('passwordUpdated', lang),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onDone,
            child: Text(AppStrings.get('done', lang)),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _SubmitButton({required this.label, required this.isSubmitting, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        child: isSubmitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
      ),
    );
  }
}
