import 'package:hive_flutter/hive_flutter.dart';
import '../models/event_model.dart';
import '../models/attachment_model.dart';
import '../config/constants.dart';

class StorageService {
  static late Box<EventModel> _eventBox;
  static late Box<dynamic> _settingsBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(EventModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AttachmentModelAdapter());
    }

    // Open Boxes
    _eventBox = await Hive.openBox<EventModel>(AppConstants.eventsBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
  }

  /// Events CRUD Operations
  static Future<void> saveEvent(EventModel event) async {
    await _eventBox.put(event.id, event);
  }

  static Future<void> deleteEvent(String eventId) async {
    await _eventBox.delete(eventId);
  }

  static EventModel? getEvent(String eventId) {
    return _eventBox.get(eventId);
  }

  static List<EventModel> getAllEvents() {
    return _eventBox.values.toList();
  }

  static List<EventModel> getEventsByDate(DateTime date) {
    return _eventBox.values.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList();
  }

  static List<EventModel> getEventsInRange(DateTime start, DateTime end) {
    return _eventBox.values.where((event) {
      return event.date.isAfter(start.subtract(const Duration(days: 1))) &&
          event.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Settings
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  /// Theme Mode
  static Future<void> saveThemeMode(String mode) async {
    await saveSetting('themeMode', mode);
  }

  static String getThemeMode() {
    return getSetting('themeMode', defaultValue: 'system') as String;
  }

  /// Clear all data
  static Future<void> clearAllData() async {
    await _eventBox.clear();
    await _settingsBox.clear();
  }

  /// Close boxes (call on app dispose)
  static Future<void> dispose() async {
    await _eventBox.close();
    await _settingsBox.close();
  }
}
