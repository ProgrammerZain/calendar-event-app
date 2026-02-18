import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/event_provider.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';
import '../common/event_list_item.dart';

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  List<DateTime> _getWeekDates(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final eventProvider = context.watch<EventProvider>();
    final weekDates = _getWeekDates(calendarProvider.focusedDate);

    return Column(
      children: [
        // Week Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: calendarProvider.goToPrevious,
              ),
              Text(
                '${DateFormat('MMM dd').format(weekDates.first)} - ${DateFormat('MMM dd, yyyy').format(weekDates.last)}',
                style: AppTextStyles.h4,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: calendarProvider.goToNext,
              ),
            ],
          ),
        ),

        // Week Days Grid
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final date = weekDates[index];
              final isSelected = isSameDay(date, calendarProvider.selectedDate);
              final isToday = isSameDay(date, DateTime.now());
              final eventsCount = eventProvider.getEventsForDate(date).length;

              return GestureDetector(
                onTap: () => calendarProvider.selectDate(date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: isToday && !isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d').format(date),
                        style: AppTextStyles.h3.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (eventsCount > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.3)
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            '$eventsCount',
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const Divider(),

        // Events for Selected Day
        Expanded(
          child: _buildEventList(context, calendarProvider, eventProvider),
        ),
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildEventList(
    BuildContext context,
    CalendarProvider calendarProvider,
    EventProvider eventProvider,
  ) {
    final events = eventProvider.getEventsForDate(calendarProvider.selectedDate);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No events scheduled',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventListItem(
          event: event,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.eventDetail,
              arguments: event,
            );
          },
        );
      },
    );
  }
}
