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
        Text(
          'Overview',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: AppConstants.spacingMD),

        // Stats cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Giving',
                value: '\$${(stats.giving.totalThisMonth / 1000).toStringAsFixed(1)}K',
                subtitle: 'This month',
                icon: Icons.volunteer_activism_rounded,
                color: AppColors.success,
                percentageChange: stats.giving.percentageChange,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: _StatCard(
                title: 'Attendance',
                value: '${stats.attendance.totalThisWeek}',
                subtitle: 'This week',
                icon: Icons.people_rounded,
                color: AppColors.info,
                percentageChange: stats.attendance.percentageChange,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMD),

        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Events',
                value: '${stats.events.upcomingEvents}',
                subtitle: 'Upcoming',
                icon: Icons.event_rounded,
                color: AppColors.warning,
                percentageChange: null,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: _StatCard(
                title: 'Members',
                value: '${stats.members.totalMembers}',
                subtitle: 'Total active',
                icon: Icons.group_rounded,
                color: AppColors.primary,
                percentageChange: stats.members.growthRate,
              ),
            ),
          ],
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
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSM),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSM),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Value
          Text(
            value,
            style: AppTextStyles.displaySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppConstants.spacingXS),

          // Subtitle and percentage
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ),
              if (percentageChange != null) ...[
                Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: 2),
                Text(
                  '${percentageChange!.abs().toStringAsFixed(1)}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isPositive ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
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
