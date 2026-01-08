import 'package:flutter/material.dart';
import 'package:shepherd_sync_mobile/core/constants/app_constants.dart';

/// Beautiful animated page indicator for onboarding
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.currentPage,
    required this.pageCount,
    super.key,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => _PageDot(
          isActive: index == currentPage,
          index: index,
          currentPage: currentPage,
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({
    required this.isActive,
    required this.index,
    required this.currentPage,
  });

  final bool isActive;
  final int index;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
      ),
    );
  }
}
