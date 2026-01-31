import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/members_state_provider.dart';

/// Bottom sheet for filtering members
class MembersFilterSheet extends ConsumerWidget {
  const MembersFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(membersProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXL),
          topRight: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Members',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(membersProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Gender filter
              Text(
                'Gender',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSM),
              Wrap(
                spacing: AppConstants.spacingSM,
                children: [
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'All',
                    isSelected: state.selectedGender == null,
                    onTap: () {
                      ref.read(membersProvider.notifier).filterByGender(null);
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Male',
                    isSelected: state.selectedGender == 'MALE',
                    onTap: () {
                      ref.read(membersProvider.notifier).filterByGender('MALE');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Female',
                    isSelected: state.selectedGender == 'FEMALE',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByGender('FEMALE');
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Membership Status filter
              Text(
                'Membership Status',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSM),
              Wrap(
                spacing: AppConstants.spacingSM,
                runSpacing: AppConstants.spacingSM,
                children: [
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'All',
                    isSelected: state.selectedMembershipStatus == null,
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMembershipStatus(null);
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Active Member',
                    isSelected:
                        state.selectedMembershipStatus == 'ACTIVE_MEMBER',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMembershipStatus('ACTIVE_MEMBER');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Regular Attendee',
                    isSelected:
                        state.selectedMembershipStatus == 'REGULAR_ATTENDEE',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMembershipStatus('REGULAR_ATTENDEE');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Visitor',
                    isSelected: state.selectedMembershipStatus == 'VISITOR',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMembershipStatus('VISITOR');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Inactive',
                    isSelected: state.selectedMembershipStatus == 'INACTIVE',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMembershipStatus('INACTIVE');
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Marital Status filter
              Text(
                'Marital Status',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSM),
              Wrap(
                spacing: AppConstants.spacingSM,
                runSpacing: AppConstants.spacingSM,
                children: [
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'All',
                    isSelected: state.selectedMaritalStatus == null,
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMaritalStatus(null);
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Single',
                    isSelected: state.selectedMaritalStatus == 'SINGLE',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMaritalStatus('SINGLE');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Married',
                    isSelected: state.selectedMaritalStatus == 'MARRIED',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMaritalStatus('MARRIED');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Divorced',
                    isSelected: state.selectedMaritalStatus == 'DIVORCED',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMaritalStatus('DIVORCED');
                    },
                  ),
                  _buildFilterChip(
                    context,
                    ref,
                    label: 'Widowed',
                    isSelected: state.selectedMaritalStatus == 'WIDOWED',
                    onTap: () {
                      ref
                          .read(membersProvider.notifier)
                          .filterByMaritalStatus('WIDOWED');
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Apply button
              CustomButton(
                text: 'Apply Filters',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMD,
          vertical: AppConstants.spacingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
