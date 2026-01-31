import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/invite_signup_screen.dart';

/// Deep link handler for invite system and other deep links
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep link listeners
  Future<void> init(BuildContext context) async {
    // Handle initial link (when app was closed and opened via link)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null && context.mounted) {
      _handleDeepLink(context, initialUri);
    }

    // Handle links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (context.mounted) {
        _handleDeepLink(context, uri);
      }
    });
  }

  /// Handle incoming deep link
  void _handleDeepLink(BuildContext context, Uri uri) {
    print('[DeepLink] Received: $uri');

    // Invite link: https://shepherdsync.app/invite/{token}
    // Or: shepherdsync://invite/{token}
    if (uri.path.startsWith('/invite/') || uri.path.startsWith('invite/')) {
      final token = uri.pathSegments.last;
      print('[DeepLink] Invite token: $token');

      // Navigate to invite signup screen
      _navigateToInviteSignup(context, token);
    } else {
      print('[DeepLink] Unknown deep link path: ${uri.path}');
    }
  }

  /// Navigate to invite signup screen
  void _navigateToInviteSignup(BuildContext context, String token) {
    print('[DeepLink] Navigating to invite signup with token: $token');

    // Navigate to InviteSignupScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteSignupScreen(inviteToken: token),
      ),
    );
  }

  /// Clean up
  void dispose() {
    _linkSubscription?.cancel();
  }
}
