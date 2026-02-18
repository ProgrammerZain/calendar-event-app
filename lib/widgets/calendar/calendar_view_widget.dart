import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calendar_provider.dart';
import 'month_view.dart';
import 'week_view.dart';
import 'day_view.dart';
import 'timeline_view.dart';

class CalendarViewWidget extends StatelessWidget {
  const CalendarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, calendarProvider, child) {
        switch (calendarProvider.calendarView) {
          case CalendarView.month:
            return const MonthView();
          case CalendarView.week:
            return const WeekView();
          case CalendarView.day:
            return const DayView();
          case CalendarView.timeline:
            return const TimelineView();
        }
      },
    );
  }
}
