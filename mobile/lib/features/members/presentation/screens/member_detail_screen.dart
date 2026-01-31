import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/members_state_provider.dart';
import 'member_form_screen.dart';

/// Member detail screen
class MemberDetailScreen extends ConsumerWidget {
  const MemberDetailScreen({
    super.key,
    required this.memberId,
  });

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(memberDetailProvider(memberId));

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe from left to right to go back
        if (details.primaryVelocity != null &&
            details.primaryVelocity! > 0 &&
            Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: memberAsync.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppConstants.spacingMD),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (member) => Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: CustomScrollView(
            slivers: [
              // Modern SliverAppBar with hero header
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberFormScreen(memberId: memberId),
                        ),
                      );

                      if (result == true && context.mounted) {
                        ref.invalidate(memberDetailProvider(memberId));
                      }
                    },
                  ),
                  // Send invite button (only if member has no user account)
                  if (member.userId == null && member.inviteStatus != 'ACTIVE')
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      tooltip: 'Send Invite',
                      onPressed: () => _showSendInviteSheet(context, member),
                    ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_rounded, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete Member'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final confirm = await _showDeleteConfirmationSheet(context);

                        if (confirm == true && context.mounted) {
                          final success = await ref
                              .read(membersProvider.notifier)
                              .deleteMember(memberId);

                          if (success && context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Member deleted')),
                            );
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 8),
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
                        top: -80,
                        right: -80,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        left: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      // Profile content
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: _buildHeroProfileCard(member),
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
                    // Contact info
                    _buildModernSection(
                      'Contact Information',
                      Icons.contacts_rounded,
                      Colors.blue,
                      [
                        if (member.email != null)
                          _buildModernInfoRow(
                            Icons.email_rounded,
                            'Email',
                            member.email!,
                          ),
                        if (member.phone != null)
                          _buildModernInfoRow(
                            Icons.phone_rounded,
                            'Phone',
                            member.phone!,
                          ),
                        if (member.address != null)
                          _buildModernInfoRow(
                            Icons.location_on_rounded,
                            'Address',
                            '${member.address!.street ?? ''}, ${member.address!.city ?? ''}, ${member.address!.state ?? ''} ${member.address!.zip ?? ''}',
                          ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Personal info
                    _buildModernSection(
                      'Personal Information',
                      Icons.person_rounded,
                      Colors.purple,
                      [
                        if (member.dateOfBirth != null)
                          _buildModernInfoRow(
                            Icons.cake_rounded,
                            'Date of Birth',
                            member.dateOfBirth!,
                          ),
                        if (member.gender != null)
                          _buildModernInfoRow(
                            Icons.badge_rounded,
                            'Gender',
                            member.gender!,
                          ),
                        if (member.maritalStatus != null)
                          _buildModernInfoRow(
                            Icons.favorite_rounded,
                            'Marital Status',
                            member.maritalStatus!.replaceAll('_', ' '),
                          ),
                        if (member.occupation != null)
                          _buildModernInfoRow(
                            Icons.work_rounded,
                            'Occupation',
                            member.occupation!,
                          ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Church info
                    _buildModernSection(
                      'Church Information',
                      Icons.church_rounded,
                      AppColors.primary,
                      [
                        if (member.joinedDate != null)
                          _buildModernInfoRow(
                            Icons.calendar_today_rounded,
                            'Joined Date',
                            member.joinedDate!,
                          ),
                        if (member.baptismDate != null)
                          _buildModernInfoRow(
                            Icons.water_drop_rounded,
                            'Baptism Date',
                            member.baptismDate!,
                          ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Emergency contact
                    if (member.emergencyContact != null)
                      _buildModernSection(
                        'Emergency Contact',
                        Icons.emergency_rounded,
                        Colors.red,
                        [
                          if (member.emergencyContact!.name != null)
                            _buildModernInfoRow(
                              Icons.person_rounded,
                              'Name',
                              member.emergencyContact!.name!,
                            ),
                          if (member.emergencyContact!.relationship != null)
                            _buildModernInfoRow(
                              Icons.family_restroom_rounded,
                              'Relationship',
                              member.emergencyContact!.relationship!,
                            ),
                          if (member.emergencyContact!.phone != null)
                            _buildModernInfoRow(
                              Icons.phone_rounded,
                              'Phone',
                              member.emergencyContact!.phone!,
                            ),
                        ],
                      ),

                    const SizedBox(height: AppConstants.spacingXL),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroProfileCard(dynamic member) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
      child: Column(
        children: [
          // Avatar with glassmorphic effect
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white,
              backgroundImage: member.photo != null
                  ? NetworkImage(member.photo!)
                  : null,
              child: member.photo == null
                  ? Text(
                      '${member.firstName[0]}${member.lastName[0]}'
                          .toUpperCase(),
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Name
          Text(
            '${member.firstName} ${member.lastName}',
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.spacingSM),

          // Status badge
          if (member.membershipStatus != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                member.membershipStatus!.replaceAll('_', ' '),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernSection(
    String title,
    IconData headerIcon,
    Color accentColor,
    List<Widget> children,
  ) {
    if (children.isEmpty) return const SizedBox.shrink();

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
          // Header with icon
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
                        color: accentColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(headerIcon, color: accentColor, size: 20),
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

  Widget _buildModernInfoRow(IconData icon, String label, String value) {
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

  Future<bool?> _showDeleteConfirmationSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
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
                    Icons.delete_rounded,
                    size: 32,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLG),

                // Title
                Text(
                  'Delete Member',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingSM),

                // Message
                Text(
                  'Are you sure you want to delete this member? This action can be undone later.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Action buttons - stacked vertically for better UX hierarchy
                Column(
                  children: [
                    // Primary action (Delete) - most prominent, at bottom
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
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

                    // Secondary action (Cancel) - less prominent
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

  /// Show send invite bottom sheet with multiple delivery options
  Future<void> _showSendInviteSheet(BuildContext context, dynamic member) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMD),

                // Title
                const Text(
                  'Send Invite',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingSM),

                // Message
                Text(
                  'How would you like to send the invite to ${member.firstName}?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLG),

                // SMS option
                if (member.phone != null)
                  _buildInviteOption(
                    context,
                    icon: Icons.sms_rounded,
                    label: 'Send via SMS',
                    subtitle: member.phone!,
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      _sendInvite(context, member.id, 'SMS');
                    },
                  ),

                if (member.phone != null) const SizedBox(height: AppConstants.spacingMD),

                // Email option
                if (member.email != null)
                  _buildInviteOption(
                    context,
                    icon: Icons.email_rounded,
                    label: 'Send via Email',
                    subtitle: member.email!,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _sendInvite(context, member.id, 'EMAIL');
                    },
                  ),

                if (member.email != null) const SizedBox(height: AppConstants.spacingMD),

                // Copy link option
                _buildInviteOption(
                  context,
                  icon: Icons.link_rounded,
                  label: 'Copy Invite Link',
                  subtitle: 'Share manually',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                    _sendInvite(context, member.id, 'MANUAL');
                  },
                ),

                const SizedBox(height: AppConstants.spacingMD),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInviteOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendInvite(BuildContext context, String memberId, String method) async {
    // TODO: Implement API call to send invite
    // final result = await membersRepository.sendInvite(memberId, method);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invite sent via $method'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
