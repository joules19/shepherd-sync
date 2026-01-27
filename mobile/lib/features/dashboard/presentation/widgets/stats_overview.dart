import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/dashboard_stats.dart';

/// Statistics overview widget showing key metrics
class StatsOverview extends StatelessWidget {
  const StatsOverview({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
          child: Text(
            'Overview',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: AppConstants.spacingMD),

        // Horizontal scrollable stats
        SizedBox(
          height: 100,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
            scrollDirection: Axis.horizontal,
            children: [
              _StatCard(
                title: 'Giving',
                value: '\$${(stats.giving.totalThisMonth / 1000).toStringAsFixed(1)}K',
                subtitle: 'This month',
                icon: Icons.volunteer_activism_rounded,
                color: AppColors.success,
                percentageChange: stats.giving.percentageChange,
              ),
              const SizedBox(width: AppConstants.spacingSM),
              _StatCard(
                title: 'Attendance',
                value: '${stats.attendance.totalThisWeek}',
                subtitle: 'This week',
                icon: Icons.people_rounded,
                color: AppColors.info,
                percentageChange: stats.attendance.percentageChange,
              ),
              const SizedBox(width: AppConstants.spacingSM),
              _StatCard(
                title: 'Events',
                value: '${stats.events.upcomingEvents}',
                subtitle: 'Upcoming',
                icon: Icons.event_rounded,
                color: AppColors.warning,
                percentageChange: null,
              ),
              const SizedBox(width: AppConstants.spacingSM),
              _StatCard(
                title: 'Members',
                value: '${stats.members.totalMembers}',
                subtitle: 'Total active',
                icon: Icons.group_rounded,
                color: AppColors.primary,
                percentageChange: stats.members.growthRate,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Individual stat card with beautiful design
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.percentageChange,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double? percentageChange;

  @override
  Widget build(BuildContext context) {
    final isPositive = (percentageChange ?? 0) >= 0;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppConstants.spacingSM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingSM),

          // Value
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),

          // Subtitle and percentage
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (percentageChange != null) ...[
                const SizedBox(width: 2),
                Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: 12,
                ),
                Text(
                  '${percentageChange!.abs().toStringAsFixed(0)}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isPositive ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
