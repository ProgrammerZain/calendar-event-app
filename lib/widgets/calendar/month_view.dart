import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/event_provider.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';
import '../common/event_list_item.dart';

class MonthView extends StatelessWidget {
  const MonthView({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final eventProvider = context.watch<EventProvider>();

    return Column(
      children: [
        // Calendar
        Card(
          margin: const EdgeInsets.all(AppSpacing.md),
          child: TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: calendarProvider.focusedDate,
            selectedDayPredicate: (day) {
              return isSameDay(calendarProvider.selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              calendarProvider.selectDate(selectedDay);
              calendarProvider.setFocusedDate(focusedDay);
            },
            onPageChanged: (focusedDay) {
              calendarProvider.setFocusedDate(focusedDay);
            },
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            eventLoader: (day) {
              return eventProvider.getEventsForDate(day);
            },
          ),
        ),

        // Event List for Selected Date
        Expanded(
          child: _buildEventList(context, calendarProvider, eventProvider),
        ),
      ],
    );
  }

  Widget _buildEventList(
    BuildContext context,
    CalendarProvider calendarProvider,
    EventProvider eventProvider,
  ) {
    final events = eventProvider.getEventsForDate(calendarProvider.selectedDate);
    final dateStr = DateFormat('EEEE, MMMM dd').format(calendarProvider.selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: AppTextStyles.h4,
              ),
              if (events.isNotEmpty)
                Text(
                  '${events.length} event${events.length > 1 ? 's' : ''}',
                  style: AppTextStyles.bodySmall,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: events.isEmpty
              ? Center(
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
                )
              : ListView.builder(
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
                ),
        ),
      ],
    );
  }
}
