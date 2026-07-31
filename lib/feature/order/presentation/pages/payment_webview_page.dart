import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../view_model/checkout_view_model.dart';
import 'order_confirmation_page.dart';

class PaymentWebviewPage extends ConsumerStatefulWidget {
  const PaymentWebviewPage({super.key});

  @override
  ConsumerState<PaymentWebviewPage> createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends ConsumerState<PaymentWebviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _handledRedirect = false;

  @override
  void initState() {
    super.initState();

    final paymentUrl = ref.read(checkoutViewModelProvider).paymentUrl!;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            // Khalti redirects the browser back to our configured FRONTEND_URL
            // return_url (…/checkout/verify?pidx=…) once the payment flow
            // ends (success, failure, or user cancel). We never want that
            // Next.js page to actually load in-app — instead we intercept
            // the navigation here and drive our own verify call with the
            // pidx we already captured from the checkout response, so the
            // whole flow stays inside the Flutter app.
            if (request.url.contains('/checkout/verify')) {
              _handleReturn();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  Future<void> _handleReturn() async {
    if (_handledRedirect) return;
    _handledRedirect = true;

    await ref.read(checkoutViewModelProvider.notifier).verifyPayment();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrderConfirmationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeViewModelProvider).language;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.get('payWithKhalti', lang),
            style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
