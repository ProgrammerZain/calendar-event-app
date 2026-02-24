import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';
import '../common/event_list_item.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  Map<String, List<dynamic>> _groupEventsByDate(List<dynamic> events) {
    final Map<String, List<dynamic>> grouped = {};

    for (var event in events) {
      final dateKey = DateFormat('yyyy-MM-dd').format(event.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(event);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final allEvents = eventProvider.events;

    if (allEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No events yet',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create your first event to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final groupedEvents = _groupEventsByDate(allEvents);
    final sortedDates = groupedEvents.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final date = DateTime.parse(dateKey);
        final events = groupedEvents[dateKey]!;

        return _buildDateSection(context, date, events);
      },
    );
  }

  Widget _buildDateSection(
      BuildContext context, DateTime date, List<dynamic> events) {
    final isToday = _isToday(date);
    final isTomorrow = _isTomorrow(date);
    final isPast =
        date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    String dateLabel;
    if (isToday) {
      dateLabel = 'Today';
    } else if (isTomorrow) {
      dateLabel = 'Tomorrow';
    } else {
      dateLabel = DateFormat('EEE, MMM dd, yyyy').format(date); // ← Shorter format
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isPast
                    ? AppColors.textDisabled
                    : isToday
                        ? AppColors.primary
                        : AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        dateLabel,
                        style: AppTextStyles.h4.copyWith(
                          color: isToday
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPast
                            ? AppColors.textDisabled.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${events.length}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Events
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            margin: const EdgeInsets.only(left: 2),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.borderLight,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              children: events.map((event) {
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: EventListItem(
                    event: event,
                    showDate: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.eventDetail,
                        arguments: event,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}
