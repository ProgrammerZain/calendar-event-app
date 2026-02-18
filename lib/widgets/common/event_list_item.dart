import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event_model.dart';
import '../../config/constants.dart';

class EventListItem extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final bool showDate;

  const EventListItem({
    super.key,
    required this.event,
    required this.onTap,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.eventBackgrounds[event.colorIndex];
    final accentColor = AppColors.eventColors[event.colorIndex];

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: accentColor,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              // Time or All Day indicator
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  children: [
                    if (event.isAllDay)
                      Text(
                        'All Day',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else if (event.startTime != null)
                      Text(
                        DateFormat('HH:mm').format(event.startTime!),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Icon(
                        Icons.event,
                        size: 20,
                        color: accentColor,
                      ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (event.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.category != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          event.category!,
                          style: AppTextStyles.caption.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Indicators
              Column(
                children: [
                  if (event.attachments != null && event.attachments!.isNotEmpty)
                    Icon(
                      Icons.attach_file,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  if (event.description != null && event.description!.isNotEmpty)
                    Icon(
                      Icons.notes,
                      size: 18,
                      color: AppColors.textSecondary,
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
