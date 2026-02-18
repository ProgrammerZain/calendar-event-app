import 'package:flutter/material.dart';

// This is a placeholder - the actual calendar is shown in HomeScreen
// You can use this for a dedicated full-screen calendar view if needed

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: const Center(
        child: Text('Calendar View'),
      ),
    );
  }
}
