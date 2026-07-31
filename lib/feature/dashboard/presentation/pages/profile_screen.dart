import 'dart:io';
import 'package:coffeshop_mobile/app/routes/app_routes.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/core/api/api_endpoints.dart';
import 'package:coffeshop_mobile/core/services/biometric/biometric_service.dart';
import 'package:coffeshop_mobile/core/services/storage/session_service.dart';
import 'package:coffeshop_mobile/core/services/storage/token_service.dart';
import 'package:coffeshop_mobile/feature/auth/domain/usecases/login_usecase.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/pages/change_password_page.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/state/auth_state.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/view_model/auth_view_model.dart';
import 'package:coffeshop_mobile/feature/order/presentation/pages/orders_list_page.dart';
import 'package:coffeshop_mobile/app/locale/app_strings.dart';
import 'package:coffeshop_mobile/app/locale/locale_state.dart';
import 'package:coffeshop_mobile/app/locale/locale_view_model.dart';
import 'package:coffeshop_mobile/app/theme/brightness_view_model.dart';
import 'package:coffeshop_mobile/app/theme/theme_state.dart';
import 'package:coffeshop_mobile/app/theme/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isEditing = false;
  File? _pendingAvatar;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 500,
      );

      if (image == null) return;

      setState(() {
        _pendingAvatar = File(image.path);
        _isEditing = true;
      });
    } catch (e) {
      if (!mounted) return;
      final lang = ref.read(localeViewModelProvider).language;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.get('failedToPickImage', lang)}: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    final lang = ref.read(localeViewModelProvider).language;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: Text(AppStrings.get('chooseFromGallery', lang),
                    style: const TextStyle(fontFamily: 'Montserrat')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(AppStrings.get('takeAPhoto', lang),
                    style: const TextStyle(fontFamily: 'Montserrat')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final lang = ref.read(localeViewModelProvider).language;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final success = await ref.read(authViewModelProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          avatarFile: _pendingAvatar,
        );

    if (success) {
      setState(() {
        _isEditing = false;
        _pendingAvatar = null;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('profileUpdatedSuccessfully', lang)),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('failedToUpdateProfile', lang)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<bool> _confirmPasswordBeforeEnabling(String email) async {
    final lang = ref.read(localeViewModelProvider).language;
    final passwordController = TextEditingController();
    bool obscure = true;
    String? errorText;
    bool isVerifying = false;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(AppStrings.get('confirmYourPassword', lang)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('enterPasswordToEnableFingerprint', lang),
                    style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: AppStrings.get('password', lang),
                      errorText: errorText,
                      suffixIcon: IconButton(
                        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setDialogState(() => obscure = !obscure),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isVerifying ? null : () => Navigator.pop(dialogContext, false),
                  child: Text(AppStrings.get('cancel', lang)),
                ),
                TextButton(
                  onPressed: isVerifying
                      ? null
                      : () async {
                          final password = passwordController.text.trim();
                          if (password.isEmpty) {
                            setDialogState(
                              () => errorText = AppStrings.get('pleaseEnterYourPassword', lang),
                            );
                            return;
                          }

                          setDialogState(() {
                            isVerifying = true;
                            errorText = null;
                          });

                          final loginUsecase = ref.read(loginUsecaseProvider);
                          final result = await loginUsecase(
                            LoginUsecaseParams(email: email, password: password),
                          );

                          if (!dialogContext.mounted) return;

                          result.fold(
                            (failure) => setDialogState(() {
                              isVerifying = false;
                              errorText = AppStrings.get('incorrectPassword', lang);
                            }),
                            (_) => Navigator.pop(dialogContext, true),
                          );
                        },
                  child: isVerifying
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppStrings.get('confirm', lang)),
                ),
              ],
            );
          },
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _onBiometricToggle(bool value, String userId, String email) async {
    final lang = ref.read(localeViewModelProvider).language;
    final session = ref.read(sessionServiceProvider);
    final tokenService = ref.read(tokenServiceProvider);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (value) {
      final passwordConfirmed = await _confirmPasswordBeforeEnabling(email);
      if (!passwordConfirmed) return;

      final biometricService = ref.read(biometricServiceProvider);
      final canUse = await biometricService.canCheckBiometrics();
      if (!canUse) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(AppStrings.get('noFingerprintSetUp', lang)),
            ),
          );
        }
        return;
      }

      final confirmed = await biometricService.authenticate(
        reason: AppStrings.get('confirmFingerprintToEnable', lang),
      );
      if (!confirmed) return;

      // _confirmPasswordBeforeEnabling above just did a real login, which
      // refreshed the active token — stash a copy for fingerprint login
      // to reuse later, since that flow has no password of its own to
      // get a fresh token with.
      final token = await tokenService.getToken();
      if (token != null) {
        await tokenService.saveBiometricToken(userId, token);
      }
    } else {
      await tokenService.removeBiometricToken(userId);
    }

    await session.setBiometricLoginEnabled(value, userId: value ? userId : null);
    if (mounted) setState(() {});
  }

  Widget _buildBiometricToggle(String userId, String email) {
    final lang = ref.watch(localeViewModelProvider).language;
    final isEnabled = ref.read(sessionServiceProvider).isBiometricLoginEnabled();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.fingerprint, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              AppStrings.get('fingerprintLogin', lang),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.appTextPrimary,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            activeThumbColor: AppColors.primary,
            onChanged: (value) => _onBiometricToggle(value, userId, email),
          ),
        ],
      ),
    );
  }

  Widget _buildThemePicker() {
    final themeState = ref.watch(themeViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    Widget option(AppThemeMode mode, IconData icon, String label) {
      final selected = themeState.mode == mode;
      return Expanded(
        child: GestureDetector(
          onTap: () => ref.read(themeViewModelProvider.notifier).setMode(mode),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(icon, size: 20, color: selected ? Colors.white : context.appTextSecondary),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              AppStrings.get('theme', lang),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.appTextPrimary,
              ),
            ),
          ),
          Row(
            children: [
              option(AppThemeMode.light, Icons.light_mode, AppStrings.get('light', lang)),
              const SizedBox(width: 8),
              option(AppThemeMode.dark, Icons.dark_mode, AppStrings.get('dark', lang)),
              const SizedBox(width: 8),
              option(AppThemeMode.auto, Icons.brightness_auto, AppStrings.get('auto', lang)),
            ],
          ),
        ],
      ),
    );
  }

  // Independent of the theme mode above on purpose — you can be on Dark
  // theme (picked manually) and still have auto brightness adjusting the
  // screen based on ambient light at the same time.
  Widget _buildAutoBrightnessToggle() {
    final brightnessState = ref.watch(brightnessViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.brightness_auto, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              AppStrings.get('autoBrightness', lang),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.appTextPrimary,
              ),
            ),
          ),
          Switch(
            value: brightnessState.autoBrightnessEnabled,
            activeThumbColor: AppColors.primary,
            onChanged: (value) => ref.read(brightnessViewModelProvider.notifier).setEnabled(value),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle() {
    final lang = ref.watch(localeViewModelProvider).language;
    final isNepali = lang == AppLanguage.nepali;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.language, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              AppStrings.get('language', lang),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.appTextPrimary,
              ),
            ),
          ),
          Text(
            isNepali ? 'ने' : 'EN',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isNepali,
            activeThumbColor: AppColors.primary,
            onChanged: (value) => ref.read(localeViewModelProvider.notifier).setLanguage(
                  value ? AppLanguage.nepali : AppLanguage.english,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final isLoading = authState.status == AuthStatus.loading;
    final lang = ref.watch(localeViewModelProvider).language;

    final avatarUrl = ApiEndpoints.resolveImageUrl(user?.avatar);

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('coffeeBeansProfile', lang),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                  _nameController.text = user?.name ?? '';
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.error),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _pendingAvatar = null;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // User Avatar with Upload Badge
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: context.appSurface,
                        backgroundImage: _pendingAvatar != null
                            ? FileImage(_pendingAvatar!) as ImageProvider
                            : (avatarUrl != null ? NetworkImage(avatarUrl) : null),
                        child: _pendingAvatar == null && avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: 64,
                                color: AppColors.primary.withValues(alpha: 0.4),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: isLoading ? null : _showImagePickerOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // User Email display card (non-editable)
              Text(
                user?.email ?? 'coffeebeans@premium.com',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: context.appTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              // Detail Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('personalDetails', lang),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Full Name Field
                    Text(
                      AppStrings.get('fullNameLabel', lang),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: context.appTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextFormField(
                            controller: _nameController,
                            style: const TextStyle(
                                fontFamily: 'Montserrat', fontSize: 14),
                            decoration: InputDecoration(
                              hintText: AppStrings.get('enterYourFullName', lang),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.get('nameIsRequired', lang);
                              }
                              return null;
                            },
                          )
                        : Text(
                            user?.name ?? 'Coffeebeans Enthusiast',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.appTextPrimary,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              if (_isEditing)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            AppStrings.get('saveChanges', lang),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )
              else ...[
                _buildThemePicker(),
                _buildAutoBrightnessToggle(),
                _buildLanguageToggle(),
                if (user != null) _buildBiometricToggle(user.id, user.email),
                // My Orders
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersListPage()),
                    ),
                    icon: const Icon(Icons.receipt_long_outlined, color: AppColors.primary),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    label: Text(
                      AppStrings.get('myOrders', lang),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Change Password
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                    ),
                    icon: const Icon(Icons.lock_outline, color: AppColors.primary),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    label: Text(
                      AppStrings.get('changePassword', lang),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref.read(authViewModelProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppStrings.get('logout', lang),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
