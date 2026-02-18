import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../models/attachment_model.dart';
import '../services/storage_service.dart';
import '../services/file_service.dart';
import 'package:uuid/uuid.dart';

class EventProvider with ChangeNotifier {
  final _uuid = const Uuid();
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize and load events
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = StorageService.getAllEvents();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get events for a specific date
  List<EventModel> getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList()
      ..sort((a, b) {
        if (a.isAllDay && !b.isAllDay) return -1;
        if (!a.isAllDay && b.isAllDay) return 1;
        if (a.startTime != null && b.startTime != null) {
          return a.startTime!.compareTo(b.startTime!);
        }
        return 0;
      });
  }

  /// Get events in date range
  List<EventModel> getEventsInRange(DateTime start, DateTime end) {
    return _events.where((event) {
      return event.date.isAfter(start.subtract(const Duration(days: 1))) &&
          event.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get marked dates for calendar (date -> event count)
  Map<DateTime, int> getMarkedDates() {
    final Map<DateTime, int> markedDates = {};
    
    for (var event in _events) {
      final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
      markedDates[dateKey] = (markedDates[dateKey] ?? 0) + 1;
    }
    
    return markedDates;
  }

  /// Add new event
  Future<void> addEvent({
    required String title,
    required DateTime date,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? location,
    List<AttachmentModel>? attachments,
    int colorIndex = 0,
    bool isAllDay = false,
    String? category,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();
      final event = EventModel(
        id: _uuid.v4(),
        title: title,
        date: date,
        startTime: startTime,
        endTime: endTime,
        description: description,
        location: location,
        attachments: attachments,
        colorIndex: colorIndex,
        createdAt: now,
        updatedAt: now,
        isAllDay: isAllDay,
        category: category,
        notes: notes,
      );

      await StorageService.saveEvent(event);
      _events.add(event);
      _events.sort((a, b) => a.date.compareTo(b.date));
      
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update event
  Future<void> updateEvent(EventModel updatedEvent) async {
    try {
      final index = _events.indexWhere((e) => e.id == updatedEvent.id);
      if (index == -1) throw Exception('Event not found');

      final eventToSave = updatedEvent.copyWith(
        updatedAt: DateTime.now(),
      );

      await StorageService.saveEvent(eventToSave);
      _events[index] = eventToSave;
      _events.sort((a, b) => a.date.compareTo(b.date));
      
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete event
  Future<void> deleteEvent(String eventId) async {
    try {
      final event = _events.firstWhere((e) => e.id == eventId);
      
      // Delete attachments
      if (event.attachments != null && event.attachments!.isNotEmpty) {
        for (var attachment in event.attachments!) {
          try {
            await FileService.deleteFile(attachment.filePath);
          } catch (e) {
            debugPrint('Failed to delete attachment: $e');
          }
        }
      }

      await StorageService.deleteEvent(eventId);
      _events.removeWhere((e) => e.id == eventId);
      
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Search events
  List<EventModel> searchEvents(String query) {
    if (query.isEmpty) return _events;
    
    final lowerQuery = query.toLowerCase();
    return _events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
          (event.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          (event.location?.toLowerCase().contains(lowerQuery) ?? false) ||
          (event.category?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Clear all events
  Future<void> clearAllEvents() async {
    try {
      // Delete all attachments
      for (var event in _events) {
        if (event.attachments != null && event.attachments!.isNotEmpty) {
          for (var attachment in event.attachments!) {
            try {
              await FileService.deleteFile(attachment.filePath);
            } catch (e) {
              debugPrint('Failed to delete attachment: $e');
            }
          }
        }
      }

      await StorageService.clearAllData();
      _events.clear();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
