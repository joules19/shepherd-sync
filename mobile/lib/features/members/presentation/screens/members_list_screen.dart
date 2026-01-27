import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/members_state_provider.dart';
import '../widgets/member_list_item.dart';
import '../widgets/members_filter_sheet.dart';
import 'member_detail_screen.dart';
import 'member_form_screen.dart';

/// Members list screen (Admin/Pastor only)
class MembersListScreen extends ConsumerStatefulWidget {
  const MembersListScreen({super.key});

  @override
  ConsumerState<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends ConsumerState<MembersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Fetch members on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(membersProvider.notifier).fetchMembers(refresh: true);
    });

    // Setup pagination scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(membersProvider.notifier).loadMore();
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MembersFilterSheet(),
    );
  }

  Future<void> _onRefresh() async {
    await ref.read(membersProvider.notifier).fetchMembers(refresh: true);
  }

  void _navigateToMemberDetail(String memberId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDetailScreen(memberId: memberId),
      ),
    );
  }

  void _navigateToAddMember() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MemberFormScreen()),
    ).then((result) {
      if (result == true) {
        // Refresh list after adding member
        ref.read(membersProvider.notifier).fetchMembers(refresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(membersProvider);
    final hasFilters =
        state.searchQuery != null ||
        state.selectedGender != null ||
        state.selectedMembershipStatus != null ||
        state.selectedMaritalStatus != null;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe from left to right to go back
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          context.go(AppRoutes.dashboard);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoutes.dashboard),
          ),
          title: const Text('Members'),
          actions: [
            // Filter button with indicator
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterSheet,
                ),
                if (hasFilters)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _navigateToAddMember,
          icon: const Icon(Icons.add),
          label: const Text('Add Member'),
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(membersProvider.notifier).search('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  ref.read(membersProvider.notifier).search(value);
                },
              ),
            ),

            // Stats card
            if (!state.isLoading && state.members.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMD,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMD),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total',
                        state.total.toString(),
                        Icons.people,
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[200]),
                      _buildStatItem(
                        'Showing',
                        state.members.length.toString(),
                        Icons.visibility,
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: AppConstants.spacingMD),

            // Members list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: _buildMembersList(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: AppConstants.spacingSM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
            ),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersList(MembersState state) {
    // Loading state (initial)
    if (state.isLoading && state.members.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (state.error != null && state.members.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: AppConstants.spacingMD),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              TextButton.icon(
                onPressed: () => ref
                    .read(membersProvider.notifier)
                    .fetchMembers(refresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (state.members.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: AppConstants.spacingMD),
              Text(
                'No members found',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSM),
              Text(
                'Add your first member to get started',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Members list
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
      itemCount: state.members.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Loading more indicator
        if (index == state.members.length) {
          return const Padding(
            padding: EdgeInsets.all(AppConstants.spacingMD),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final member = state.members[index];
        return MemberListItem(
          member: member,
          onTap: () => _navigateToMemberDetail(member.id),
        );
      },
    );
  }
}
