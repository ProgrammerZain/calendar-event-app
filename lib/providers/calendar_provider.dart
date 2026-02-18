import 'package:flutter/foundation.dart';
import '../config/constants.dart';

enum CalendarView { month, week, day, timeline }

class CalendarProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  CalendarView _calendarView = CalendarView.month;

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  CalendarView get calendarView => _calendarView;

  /// Select a date
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Change focused month/week
  void setFocusedDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  /// Change calendar view
  void setCalendarView(CalendarView view) {
    _calendarView = view;
    notifyListeners();
  }

  /// Go to today
  void goToToday() {
    final today = DateTime.now();
    _selectedDate = today;
    _focusedDate = today;
    notifyListeners();
  }

  /// Navigate to next period (month/week/day based on view)
  void goToNext() {
    switch (_calendarView) {
      case CalendarView.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
        break;
      case CalendarView.week:
        _focusedDate = _focusedDate.add(const Duration(days: 7));
        break;
      case CalendarView.day:
      case CalendarView.timeline:
        _focusedDate = _focusedDate.add(const Duration(days: 1));
        break;
    }
    notifyListeners();
  }

  /// Navigate to previous period
  void goToPrevious() {
    switch (_calendarView) {
      case CalendarView.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
        break;
      case CalendarView.week:
        _focusedDate = _focusedDate.subtract(const Duration(days: 7));
        break;
      case CalendarView.day:
      case CalendarView.timeline:
        _focusedDate = _focusedDate.subtract(const Duration(days: 1));
        break;
    }
    notifyListeners();
  }
}
