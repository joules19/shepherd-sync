import 'package:flutter/material.dart';

/// Model representing a single onboarding page
class OnboardingPageModel {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

/// Static content for all onboarding pages
class OnboardingContent {
  OnboardingContent._();

  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Welcome to\nShepherdSync',
      description:
          'Your complete church management solution. Connect, engage, and grow your faith community.',
      icon: Icons.waving_hand_rounded,
      gradientColors: [
        Color(0xFF713784), // Deep purple
        Color(0xFF8B5CF6), // Light purple
      ],
    ),
    OnboardingPageModel(
      title: 'Stay Connected',
      description:
          'Never miss important announcements, events, or updates from your church family.',
      icon: Icons.people_rounded,
      gradientColors: [
        Color(0xFF8B5CF6), // Light purple
        Color(0xFFA78BFA), // Lighter purple
      ],
    ),
    OnboardingPageModel(
      title: 'Give with Ease',
      description: 'Support your church with secure, convenient giving.',
      icon: Icons.volunteer_activism_rounded,
      gradientColors: [
        Color(0xFFA78BFA), // Lighter purple
        Color(0xFFC4B5FD), // Very light purple
      ],
    ),
    OnboardingPageModel(
      title: 'Engage & Grow',
      description:
          'Register for events, check-in attendance, explore media gallery, and be part of the community.',
      icon: Icons.celebration_rounded,
      gradientColors: [
        Color(0xFFC4B5FD), // Very light purple
        Color(0xFFDDD6FE), // Ultra light purple
      ],
    ),
  ];
}
