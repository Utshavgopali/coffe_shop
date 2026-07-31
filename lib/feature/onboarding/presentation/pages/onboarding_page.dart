import 'package:coffeshop_mobile/app/locale/app_strings.dart';
import 'package:coffeshop_mobile/app/locale/locale_state.dart';
import 'package:coffeshop_mobile/app/locale/locale_view_model.dart';
import 'package:coffeshop_mobile/app/routes/app_routes.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/feature/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:coffeshop_mobile/feature/onboarding/presentation/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<OnboardingData> _pages(AppLanguage lang) => [
        OnboardingData(
          title: AppStrings.get('onboardTitle1', lang),
          subtitle: AppStrings.get('onboardSubtitle1', lang),
          image: 'assets/images/coffee_1.jpg',
          backgroundColor: const Color(0xFFF5EBE0),
        ),
        OnboardingData(
          title: AppStrings.get('onboardTitle2', lang),
          subtitle: AppStrings.get('onboardSubtitle2', lang),
          image: 'assets/images/coffee_4.jpg',
          backgroundColor: const Color(0xFFFFF3E8),
        ),
        OnboardingData(
          title: AppStrings.get('onboardTitle3', lang),
          subtitle: AppStrings.get('onboardSubtitle3', lang),
          image: 'assets/images/coffee_6.jpg',
          backgroundColor: const Color(0xFFEDE0D4),
        ),
      ];

  static const _pageCount = 3;

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pageCount - 1;
    final lang = ref.watch(localeViewModelProvider).language;
    final pages = _pages(lang);

    return Scaffold(
      backgroundColor: pages[_currentPage].backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 20, 0),
                child: isLast
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: _skip,
                        child: Text(
                          AppStrings.get('skip', lang),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) =>
                    OnboardingContent(data: pages[i]),
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  // Page indicator
                  PageIndicator(
                    count: pages.length,
                    current: _currentPage,
                  ),
                  const SizedBox(height: 32),

                  // Next / Get started button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isLast ? AppStrings.get('getStarted', lang) : AppStrings.get('next', lang),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}