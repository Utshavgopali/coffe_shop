import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../state/checkout_state.dart';
import '../view_model/checkout_view_model.dart';
import 'payment_webview_page.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _streetCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(checkoutViewModelProvider.notifier).startCheckout(
          ShippingAddressEntity(
            fullName: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            city: _cityCtrl.text.trim(),
            street: _streetCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CheckoutState>(checkoutViewModelProvider, (previous, next) {
      if (next.status == CheckoutStatus.awaitingPayment && next.paymentUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentWebviewPage()),
        );
      } else if (next.status == CheckoutStatus.failed && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    final state = ref.watch(checkoutViewModelProvider);
    final isSubmitting = state.status == CheckoutStatus.submittingCheckout;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.get('checkout', lang),
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, color: AppColors.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('shippingDetails', lang),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 16),
                _field(_nameCtrl, AppStrings.get('fullName', lang), Icons.person_outline, lang),
                const SizedBox(height: 14),
                _field(_phoneCtrl, AppStrings.get('phone', lang), Icons.phone_outlined, lang,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 14),
                _field(_cityCtrl, AppStrings.get('city', lang), Icons.location_city_outlined, lang),
                const SizedBox(height: 14),
                _field(_streetCtrl, AppStrings.get('streetAddress', lang), Icons.home_outlined, lang),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submit,
                    child: isSubmitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            AppStrings.get('payWithKhalti', lang),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    AppLanguage lang, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
      validator: (v) => (v == null || v.trim().isEmpty)
          ? '$label ${AppStrings.get('isRequiredSuffix', lang)}'
          : null,
    );
  }
}
