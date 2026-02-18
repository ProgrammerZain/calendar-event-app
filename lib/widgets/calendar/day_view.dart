import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';

class DayView extends StatefulWidget {
  const DayView({super.key});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= AppConstants.calendarStartHour && 
        hour <= AppConstants.calendarEndHour) {
      final offset = (hour - AppConstants.calendarStartHour) * 
          AppConstants.hourHeight;
      
      _scrollController.animateTo(
        offset - 100,
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final eventProvider = context.watch<EventProvider>();

    return Column(
      children: [
        // Date Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: calendarProvider.goToPrevious,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE').format(calendarProvider.selectedDate),
                    style: AppTextStyles.h3,
                  ),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(calendarProvider.selectedDate),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: calendarProvider.goToNext,
              ),
            ],
          ),
        ),

        const Divider(),

        // Time Grid
        Expanded(
          child: _buildTimeGrid(context, calendarProvider, eventProvider),
        ),
      ],
    );
  }

  Widget _buildTimeGrid(
    BuildContext context,
    CalendarProvider calendarProvider,
    EventProvider eventProvider,
  ) {
    final events = eventProvider.getEventsForDate(calendarProvider.selectedDate);
    final totalHours = AppConstants.calendarEndHour - AppConstants.calendarStartHour + 1;

    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: totalHours * AppConstants.hourHeight,
        child: Stack(
          children: [
            // Time labels and grid lines
            _buildTimeLabels(totalHours),
            
            // Events
            ..._buildEventWidgets(events),

            // Current time indicator
            if (_isToday(calendarProvider.selectedDate)) _buildCurrentTimeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLabels(int totalHours) {
    return Column(
      children: List.generate(totalHours, (index) {
        final hour = AppConstants.calendarStartHour + index;
        return Container(
          height: AppConstants.hourHeight,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.borderLight),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppConstants.timeColumnWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4),
                  child: Text(
                    _formatHour(hour),
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildEventWidgets(List<EventModel> events) {
    return events.where((e) => !e.isAllDay && e.startTime != null).map((event) {
      final startHour = event.startTime!.hour;
      final startMinute = event.startTime!.minute;
      
      final endHour = event.endTime?.hour ?? (startHour + 1);
      final endMinute = event.endTime?.minute ?? 0;

      final topOffset = ((startHour - AppConstants.calendarStartHour) * 
          AppConstants.hourHeight) + 
          (startMinute / 60 * AppConstants.hourHeight);
      
      final duration = ((endHour - startHour) * 60 + (endMinute - startMinute)) / 60;
      final height = duration * AppConstants.hourHeight;

      return Positioned(
        top: topOffset,
        left: AppConstants.timeColumnWidth + 8,
        right: 8,
        height: height,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.eventDetail,
              arguments: event,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.eventBackgrounds[event.colorIndex],
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border(
                left: BorderSide(
                  color: AppColors.eventColors[event.colorIndex],
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.eventColors[event.colorIndex],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (event.location != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.eventColors[event.colorIndex],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.eventColors[event.colorIndex],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCurrentTimeIndicator() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    if (hour < AppConstants.calendarStartHour || 
        hour > AppConstants.calendarEndHour) {
      return const SizedBox.shrink();
    }

    final topOffset = ((hour - AppConstants.calendarStartHour) * 
        AppConstants.hourHeight) + 
        (minute / 60 * AppConstants.hourHeight);

    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour < 12) return '$hour AM';
    return '${hour - 12} PM';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
}
