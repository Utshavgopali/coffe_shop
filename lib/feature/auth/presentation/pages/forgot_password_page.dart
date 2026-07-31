import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../state/forgot_password_state.dart';
import '../view_model/forgot_password_view_model.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    ref.read(forgotPasswordViewModelProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final isSubmitting = state.status == ForgotPasswordStatus.submitting;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('resetPasswordTitle', lang),
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
              if (state.step != ForgotPasswordStep.done) _StepIndicator(step: state.step, lang: lang),
              const SizedBox(height: 24),
              if (state.infoMessage != null)
                _Banner(text: state.infoMessage!, color: AppColors.success),
              if (state.errorMessage != null)
                _Banner(text: state.errorMessage!, color: AppColors.error),
              switch (state.step) {
                ForgotPasswordStep.email => _EmailStep(
                    formKey: _emailFormKey,
                    controller: _emailCtrl,
                    isSubmitting: isSubmitting,
                    lang: lang,
                    onSubmit: () {
                      if (!_emailFormKey.currentState!.validate()) return;
                      ref
                          .read(forgotPasswordViewModelProvider.notifier)
                          .requestCode(_emailCtrl.text.trim());
                    },
                  ),
                ForgotPasswordStep.code => _CodeStep(
                    formKey: _codeFormKey,
                    controller: _codeCtrl,
                    email: state.email,
                    isSubmitting: isSubmitting,
                    lang: lang,
                    onSubmit: () {
                      if (!_codeFormKey.currentState!.validate()) return;
                      ref
                          .read(forgotPasswordViewModelProvider.notifier)
                          .verifyCode(_codeCtrl.text.trim());
                    },
                    onResend: () =>
                        ref.read(forgotPasswordViewModelProvider.notifier).resendCode(),
                  ),
                ForgotPasswordStep.newPassword => _NewPasswordStep(
                    formKey: _resetFormKey,
                    passwordCtrl: _newPasswordCtrl,
                    confirmCtrl: _confirmPasswordCtrl,
                    obscure: _obscure,
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                    isSubmitting: isSubmitting,
                    lang: lang,
                    onSubmit: () {
                      if (!_resetFormKey.currentState!.validate()) return;
                      ref
                          .read(forgotPasswordViewModelProvider.notifier)
                          .resetPassword(_newPasswordCtrl.text);
                    },
                  ),
                ForgotPasswordStep.done => _DoneStep(
                    lang: lang,
                    onDone: () => Navigator.popUntil(context, (route) => route.isFirst),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final ForgotPasswordStep step;
  final AppLanguage lang;

  const _StepIndicator({required this.step, required this.lang});

  @override
  Widget build(BuildContext context) {
    final index = switch (step) {
      ForgotPasswordStep.email => 0,
      ForgotPasswordStep.code => 1,
      ForgotPasswordStep.newPassword => 2,
      ForgotPasswordStep.done => 3,
    };

    final labels = [
      AppStrings.get('stepEmail', lang),
      AppStrings.get('stepVerify', lang),
      AppStrings.get('stepNewPassword', lang),
    ];

    return Row(
      children: List.generate(labels.length, (i) {
        final isActive = i <= index;
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 6,
                margin: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 6),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : context.appBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primary : context.appTextSecondary,
                ),
              ),
            ],
          ),
        );
      }),
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
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Montserrat', color: color, fontSize: 13),
      ),
    );
  }
}

class _EmailStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isSubmitting;
  final AppLanguage lang;
  final VoidCallback onSubmit;

  const _EmailStep({
    required this.formKey,
    required this.controller,
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
            AppStrings.get('forgotYourPassword', lang),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.get('enterEmailForCode', lang),
            style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppStrings.get('email', lang),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return AppStrings.get('emailIsRequired', lang);
              if (!v.contains('@')) return AppStrings.get('enterAValidEmail', lang);
              return null;
            },
          ),
          const SizedBox(height: 24),
          _SubmitButton(label: AppStrings.get('sendCode', lang), isSubmitting: isSubmitting, onPressed: onSubmit),
        ],
      ),
    );
  }
}

class _CodeStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String email;
  final bool isSubmitting;
  final AppLanguage lang;
  final VoidCallback onSubmit;
  final VoidCallback onResend;

  const _CodeStep({
    required this.formKey,
    required this.controller,
    required this.email,
    required this.isSubmitting,
    required this.lang,
    required this.onSubmit,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('checkYourInbox', lang),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.get('enter6DigitCodeSentTo', lang)} $email.',
            style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller,
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
          _SubmitButton(label: AppStrings.get('verifyCode', lang), isSubmitting: isSubmitting, onPressed: onSubmit),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: isSubmitting ? null : onResend,
              child: Text(AppStrings.get('resendCode', lang), style: const TextStyle(color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewPasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final bool isSubmitting;
  final AppLanguage lang;
  final VoidCallback onSubmit;

  const _NewPasswordStep({
    required this.formKey,
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
            AppStrings.get('setANewPassword', lang),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 24),
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
          _SubmitButton(label: AppStrings.get('resetPasswordButton', lang), isSubmitting: isSubmitting, onPressed: onSubmit),
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
          AppStrings.get('passwordReset', lang),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.get('canNowLoginWithNewPassword', lang),
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onDone,
            child: Text(AppStrings.get('backToSignIn', lang)),
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
