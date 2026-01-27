import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/announcement.dart';

/// Announcements carousel with beautiful cards
class AnnouncementsCarousel extends StatelessWidget {
  const AnnouncementsCarousel({
    super.key,
    required this.announcements,
  });

  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    if (announcements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Announcements',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all announcements
                },
                child: Text(
                  'See All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingSM),

        // Carousel - More compact
        SizedBox(
          height: 110,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
            scrollDirection: Axis.horizontal,
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < announcements.length - 1
                      ? AppConstants.spacingSM
                      : 0,
                ),
                child: AnnouncementCard(announcement: announcements[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual announcement card
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'urgent':
        return AppColors.error;
      case 'event':
        return AppColors.warning;
      case 'general':
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(announcement.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to announcement detail
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(AppConstants.spacingSM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor,
                categoryColor.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: categoryColor.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      announcement.category.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.campaign_rounded,
                    size: 20,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingSM),

              // Title
              Text(
                announcement.title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Message
              Expanded(
                child: Text(
                  announcement.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: AppConstants.spacingXS),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(announcement.createdAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
