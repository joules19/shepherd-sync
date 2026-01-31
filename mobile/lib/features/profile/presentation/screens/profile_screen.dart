import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

/// Beautiful profile screen showing user's information
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Clean phone country code by removing duplicate + signs
  String _cleanPhoneCountryCode(String? code) {
    if (code == null || code.isEmpty) return '';
    // Remove all + signs and add back a single one
    final cleaned = code.replaceAll('+', '').trim();
    return cleaned.isNotEmpty ? '+$cleaned' : '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Hero Header with Profile Picture
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(AppRoutes.dashboard),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () {
                  // Navigate to edit profile
                  context.push(AppRoutes.editProfile);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),

                  // Decorative circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // Profile content at bottom
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: _buildProfileHeader(user),
                  ),
                ],
              ),
            ),
          ),

          // Content sections
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppConstants.spacingSM),

                // Personal Information Section
                _buildSection(
                  title: 'Personal Information',
                  icon: Icons.person_rounded,
                  accentColor: Colors.blue,
                  children: [
                    _buildInfoRow(
                      Icons.badge_rounded,
                      'Full Name',
                      '${user.firstName} ${user.lastName}',
                    ),
                    _buildInfoRow(
                      Icons.email_rounded,
                      'Email',
                      user.email,
                    ),
                    if (user.phone != null)
                      _buildInfoRow(
                        Icons.phone_rounded,
                        'Phone',
                        '${_cleanPhoneCountryCode(user.phoneCountryCode)} ${user.phone}',
                      ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingMD),

                // Organization Section
                _buildSection(
                  title: 'Organization',
                  icon: Icons.church_rounded,
                  accentColor: AppColors.primary,
                  children: [
                    _buildInfoRow(
                      Icons.admin_panel_settings_rounded,
                      'Role',
                      _getRoleDisplay(user.role),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingMD),

                // Settings Section
                _buildSection(
                  title: 'Settings',
                  icon: Icons.settings_rounded,
                  accentColor: Colors.purple,
                  children: [
                    _buildSettingsTile(
                      context,
                      Icons.notifications_rounded,
                      'Notifications',
                      'Manage notification preferences',
                      () {
                        context.push(AppRoutes.notificationSettings);
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      context,
                      Icons.lock_rounded,
                      'Change Password',
                      'Update your password',
                      () {
                        // Navigate to change password
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingMD),

                // Logout Button
                _buildLogoutButton(context, ref),

                const SizedBox(height: AppConstants.spacingXL),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        // Profile Picture
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: user.avatar != null
                ? CachedNetworkImage(
                    imageUrl: user.avatar!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildAvatarPlaceholder(),
                  )
                : _buildAvatarPlaceholder(),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMD),

        // Name
        Text(
          '${user.firstName} ${user.lastName}',
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // Role badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getRoleDisplay(user.role),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Icon(
        Icons.person_rounded,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color accentColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.08),
                  accentColor.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                const SizedBox(width: AppConstants.spacingMD),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: AppConstants.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.grey[600]),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.spacingMD),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.logout_rounded,
            size: 20,
            color: Colors.red,
          ),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text(
          'Sign out of your account',
          style: TextStyle(
            color: Colors.red,
            fontSize: 13,
          ),
        ),
        onTap: () async {
          final confirmed = await _showLogoutConfirmation(context);
          if (confirmed == true) {
            await ref.read(authStateProvider.notifier).logout();
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          }
        },
      ),
    );
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Draggable handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Title
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSM),

                // Message
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Yes, Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleDisplay(String role) {
    switch (role.toUpperCase()) {
      case 'SUPER_ADMIN':
        return 'Super Admin';
      case 'ADMIN':
        return 'Admin';
      case 'PASTOR':
        return 'Pastor';
      case 'USHER':
        return 'Usher';
      case 'MEMBER':
        return 'Member';
      case 'PARENT':
        return 'Parent';
      default:
        return role;
    }
  }
}
