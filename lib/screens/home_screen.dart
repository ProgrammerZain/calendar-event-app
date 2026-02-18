import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/calendar_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/calendar/calendar_view_widget.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/custom_fab.dart';
import '../config/routes.dart';
import '../config/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final eventProvider = context.read<EventProvider>();
    await eventProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.appName,
        actions: [
          _buildViewSwitcher(),
          _buildThemeToggle(),
        ],
      ),
      body: SafeArea(
        child: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            if (eventProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (eventProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${eventProvider.error}',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const CalendarViewWidget();
          },
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          final selectedDate = context.read<CalendarProvider>().selectedDate;
          Navigator.pushNamed(
            context,
            AppRoutes.eventForm,
            arguments: {'initialDate': selectedDate},
          );
        },
      ),
    );
  }

  Widget _buildViewSwitcher() {
    return Consumer<CalendarProvider>(
      builder: (context, calendarProvider, child) {
        return PopupMenuButton<CalendarView>(
          icon: const Icon(Icons.view_module_outlined),
          onSelected: (view) {
            calendarProvider.setCalendarView(view);
          },
          itemBuilder: (context) => [
            _buildViewMenuItem(CalendarView.month, 'Month View', Icons.calendar_month),
            _buildViewMenuItem(CalendarView.week, 'Week View', Icons.view_week),
            _buildViewMenuItem(CalendarView.day, 'Day View', Icons.view_day),
            _buildViewMenuItem(CalendarView.timeline, 'Timeline', Icons.timeline),
          ],
        );
      },
    );
  }

  PopupMenuItem<CalendarView> _buildViewMenuItem(
    CalendarView view,
    String title,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: view,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<AppThemeMode>(
          icon: Icon(
            themeProvider.themeMode == AppThemeMode.dark
                ? Icons.dark_mode
                : themeProvider.themeMode == AppThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto,
          ),
          onSelected: (mode) {
            themeProvider.setThemeMode(mode);
          },
          itemBuilder: (context) => [
            _buildThemeMenuItem(AppThemeMode.light, 'Light', Icons.light_mode),
            _buildThemeMenuItem(AppThemeMode.dark, 'Dark', Icons.dark_mode),
            _buildThemeMenuItem(AppThemeMode.system, 'System', Icons.brightness_auto),
          ],
        );
      },
    );
  }

  PopupMenuItem<AppThemeMode> _buildThemeMenuItem(
    AppThemeMode mode,
    String title,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: mode,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }
}
