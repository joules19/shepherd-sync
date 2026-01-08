import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shepherd_sync_mobile/core/constants/app_constants.dart';
import 'package:shepherd_sync_mobile/core/constants/app_text_styles.dart';
import 'package:shepherd_sync_mobile/features/dashboard/data/models/quick_action.dart';

/// Beautiful quick action card with icon and gradient
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.action,
    super.key,
  });

  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(action.route),
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                action.color,
                action.color.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            boxShadow: [
              BoxShadow(
                color: action.color.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMD),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  ),
                  child: Icon(
                    action.icon,
                    color: Colors.white,
                    size: AppConstants.iconSizeLG,
                  ),
                ),

                const Spacer(),

                // Title
                Text(
                  action.title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppConstants.spacingXS),

                // Subtitle
                Text(
                  action.subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
