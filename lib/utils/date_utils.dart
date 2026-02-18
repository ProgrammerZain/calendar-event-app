import 'package:intl/intl.dart';

class AppDateUtils {
  /// Format date to display format
  static String formatDisplayDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  /// Format time to display format
  static String formatDisplayTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  /// Format date and time
  static String formatDisplayDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Get start of week
  static DateTime startOfWeek(DateTime date) {
    final daysToSubtract = date.weekday % 7;
    return startOfDay(date.subtract(Duration(days: daysToSubtract)));
  }

  /// Get end of week
  static DateTime endOfWeek(DateTime date) {
    final daysToAdd = 6 - (date.weekday % 7);
    return endOfDay(date.add(Duration(days: daysToAdd)));
  }

  /// Get relative date string (Today, Tomorrow, Yesterday, etc.)
  static String getRelativeDateString(DateTime date) {
    final now = DateTime.now();
    final today = startOfDay(now);
    final targetDate = startOfDay(date);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference > 1 && difference <= 7) {
      return DateFormat('EEEE').format(date);
    }

    return formatDisplayDate(date);
  }
}
