import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/members_state_provider.dart';
import '../widgets/member_list_item.dart';
import '../widgets/members_filter_sheet.dart';
import 'add_member_screen.dart';
import 'member_detail_screen.dart';

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
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
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
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Modern compact SliverAppBar with gradient
              SliverAppBar(
                expandedHeight: 170,
                floating: false,
                pinned: true,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go(AppRoutes.dashboard),
                ),
                actions: [
                  // Filter button with indicator
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          color: Colors.white,
                        ),
                        onPressed: _showFilterSheet,
                      ),
                      if (hasFilters)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Members',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
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
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Search bar section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spacingMD,
                    AppConstants.spacingLG,
                    AppConstants.spacingMD,
                    AppConstants.spacingSM,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search members...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(membersProvider.notifier).search('');
                                },
                              )
                            : null,
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingMD,
                          vertical: AppConstants.spacingMD,
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(membersProvider.notifier).search(value);
                      },
                    ),
                  ),
                ),
              ),

              // Modern Stats Cards
              if (state.isLoading && state.members.isEmpty)
                // Show shimmer stats during loading
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMD,
                      vertical: AppConstants.spacingSM,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildShimmerStatCard()),
                        const SizedBox(width: AppConstants.spacingMD),
                        Expanded(child: _buildShimmerStatCard()),
                      ],
                    ),
                  ),
                )
              else if (!state.isLoading && state.members.isNotEmpty)
                // Show actual stats when loaded
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMD,
                      vertical: AppConstants.spacingSM,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildModernStatCard(
                            'Total Members',
                            state.total.toString(),
                            Icons.people_rounded,
                            LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.1),
                                AppColors.primary.withValues(alpha: 0.05),
                              ],
                            ),
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMD),
                        Expanded(
                          child: _buildModernStatCard(
                            'Showing',
                            state.members.length.toString(),
                            Icons.visibility_rounded,
                            LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: 0.1),
                                Colors.blue.withValues(alpha: 0.05),
                              ],
                            ),
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: AppConstants.spacingSM),
              ),

              // Members list - using sliver list directly
              _buildMembersListSliver(state),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: _navigateToAddMember,
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              'Add Member',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatCard(
    String label,
    String value,
    IconData icon,
    Gradient gradient,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppConstants.spacingSM),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersListSliver(MembersState state) {
    // Loading state (initial) - Show shimmer skeleton
    if (state.isLoading && state.members.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildShimmerMemberItem(),
            childCount: 6, // Show 6 skeleton items
          ),
        ),
      );
    }

    // Error state
    if (state.error != null && state.members.isEmpty) {
      return SliverFillRemaining(
        child: Center(
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
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Empty state
    if (state.members.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people_outline_rounded,
                    size: 64,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLG),
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
        ),
      );
    }

    // Members list
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          // Loading more indicator
          if (index == state.members.length) {
            return const Padding(
              padding: EdgeInsets.all(AppConstants.spacingLG),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          final member = state.members[index];
          return MemberListItem(
            member: member,
            onTap: () => _navigateToMemberDetail(member.id),
          );
        }, childCount: state.members.length + (state.isLoadingMore ? 1 : 0)),
      ),
    );
  }

  Widget _buildShimmerStatCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSM),

          // Label shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 60,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Value shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerMemberItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMD),

          // Text content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
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
