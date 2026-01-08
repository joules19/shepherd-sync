import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shepherd_sync_mobile/core/constants/app_constants.dart';
import 'package:shepherd_sync_mobile/core/constants/app_text_styles.dart';
import 'package:shepherd_sync_mobile/core/constants/app_routes.dart';
import 'package:shepherd_sync_mobile/core/widgets/custom_button.dart';
import 'package:shepherd_sync_mobile/features/onboarding/data/models/onboarding_page_model.dart';
import 'package:shepherd_sync_mobile/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:shepherd_sync_mobile/features/onboarding/presentation/widgets/onboarding_page_widget.dart';
import 'package:shepherd_sync_mobile/features/onboarding/presentation/widgets/page_indicator.dart';

/// Beautiful onboarding screen with smooth page transitions
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < OnboardingContent.pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == OnboardingContent.pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // PageView with onboarding pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: OnboardingContent.pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: OnboardingContent.pages[index]);
            },
          ),

          // Skip button (hidden on last page)
          if (!isLastPage)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppConstants.spacingMD,
              right: AppConstants.spacingXL,
              child: _SkipButton(onPressed: _skipOnboarding),
            ),

          // Bottom controls
          Positioned(
            bottom:
                MediaQuery.of(context).padding.bottom + AppConstants.spacingXXL,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                PageIndicator(
                  currentPage: _currentPage,
                  pageCount: OnboardingContent.pages.length,
                ),

                const SizedBox(height: AppConstants.spacingXXL),

                // Next/Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingXL,
                  ),
                  child: _NextButton(
                    isLastPage: isLastPage,
                    onPressed: _nextPage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skip button with fade animation
class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLG,
          vertical: AppConstants.spacingMD,
        ),
      ),
      child: Text(
        'Skip',
        style: AppTextStyles.button.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Next/Get Started button with smooth animations
class _NextButton extends StatelessWidget {
  const _NextButton({required this.isLastPage, required this.onPressed});

  final bool isLastPage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: CustomButton(
        onPressed: onPressed,
        text: isLastPage ? 'Get Started' : 'Next',
        textColor: isLastPage ? Color(0xFF713784) : Color(0xFF713784),
        icon: isLastPage
            ? const Icon(Icons.arrow_forward_rounded, color: Color(0xFF713784))
            : null,
        backgroundColor: Colors.white,
      ),
    );
  }
}
