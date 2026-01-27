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
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Member Details'),
          actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MemberFormScreen(memberId: memberId),
                ),
              );

              if (result == true && context.mounted) {
                // Refresh member details
                ref.invalidate(memberDetailProvider(memberId));
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Member'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'delete') {
                // Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Member'),
                    content: const Text(
                      'Are you sure you want to delete this member? This action can be undone later.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

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
        ],
      ),
      body: memberAsync.when(
        data: (member) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLG),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        backgroundImage: member.photo != null
                            ? NetworkImage(member.photo!)
                            : null,
                        child: member.photo == null
                            ? Text(
                                '${member.firstName[0]}${member.lastName[0]}'
                                    .toUpperCase(),
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(height: AppConstants.spacingMD),

                      // Name
                      Text(
                        '${member.firstName} ${member.lastName}',
                        style: AppTextStyles.headlineLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppConstants.spacingSM),

                      // Status badge
                      if (member.membershipStatus != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingMD,
                            vertical: AppConstants.spacingSM,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusFull,
                            ),
                          ),
                          child: Text(
                            member.membershipStatus!.replaceAll('_', ' '),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Contact info
              _buildSection(
                'Contact Information',
                [
                  if (member.email != null)
                    _buildInfoRow(
                      Icons.email_outlined,
                      'Email',
                      member.email!,
                    ),
                  if (member.phone != null)
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'Phone',
                      member.phone!,
                    ),
                  if (member.address != null)
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'Address',
                      '${member.address!.street ?? ''}, ${member.address!.city ?? ''}, ${member.address!.state ?? ''} ${member.address!.zip ?? ''}',
                    ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Personal info
              _buildSection(
                'Personal Information',
                [
                  if (member.dateOfBirth != null)
                    _buildInfoRow(
                      Icons.cake_outlined,
                      'Date of Birth',
                      member.dateOfBirth!,
                    ),
                  if (member.gender != null)
                    _buildInfoRow(
                      Icons.person_outline,
                      'Gender',
                      member.gender!,
                    ),
                  if (member.maritalStatus != null)
                    _buildInfoRow(
                      Icons.favorite_outline,
                      'Marital Status',
                      member.maritalStatus!.replaceAll('_', ' '),
                    ),
                  if (member.occupation != null)
                    _buildInfoRow(
                      Icons.work_outline,
                      'Occupation',
                      member.occupation!,
                    ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Church info
              _buildSection(
                'Church Information',
                [
                  if (member.joinedDate != null)
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Joined Date',
                      member.joinedDate!,
                    ),
                  if (member.baptismDate != null)
                    _buildInfoRow(
                      Icons.water_drop_outlined,
                      'Baptism Date',
                      member.baptismDate!,
                    ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Emergency contact
              if (member.emergencyContact != null)
                _buildSection(
                  'Emergency Contact',
                  [
                    if (member.emergencyContact!.name != null)
                      _buildInfoRow(
                        Icons.person_outline,
                        'Name',
                        member.emergencyContact!.name!,
                      ),
                    if (member.emergencyContact!.relationship != null)
                      _buildInfoRow(
                        Icons.family_restroom,
                        'Relationship',
                        member.emergencyContact!.relationship!,
                      ),
                    if (member.emergencyContact!.phone != null)
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'Phone',
                        member.emergencyContact!.phone!,
                      ),
                  ],
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
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
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: AppConstants.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
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
