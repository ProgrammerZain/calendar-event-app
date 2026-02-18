import 'package:calendar_event_app/models/event_model.dart';
import 'package:calendar_event_app/screens/calendar_screen.dart';
import 'package:calendar_event_app/screens/event_detail_screen.dart';
import 'package:calendar_event_app/screens/event_form_screen.dart';
import 'package:calendar_event_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String calendar = '/calendar';
  static const String eventForm = '/event-form';
  static const String eventDetail = '/event-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());

      case eventForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EventFormScreen(
            event: args?['event'] as EventModel?,
            initialDate: args?['initialDate'] as DateTime?,
          ),
        );

      case eventDetail:
        final event = settings.arguments as EventModel;
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(event: event),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
