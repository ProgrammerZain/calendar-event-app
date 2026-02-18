import 'package:flutter/material.dart';

/// App-wide constants - NO HARDCODING ANYWHERE ELSE
class AppConstants {
  // App Info
  static const String appName = 'Calendar Events';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String themeBoxName = 'themeBox';
  static const String eventsBoxName = 'eventsBox';
  static const String settingsBoxName = 'settingsBox';

  // Calendar Settings
  static const int calendarStartHour = 6;
  static const int calendarEndHour = 22;
  static const double hourHeight = 60.0;
  static const double timeColumnWidth = 60.0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 2.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocExtensions = ['pdf', 'doc', 'docx'];

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';

  // Calendar View Types
  static const String monthView = 'month';
  static const String weekView = 'week';
  static const String dayView = 'day';
  static const String timelineView = 'timeline';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

/// Color Schemes
class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF226278);
  static const Color primaryLight = Color(0xFF4A8FA8);
  static const Color primaryDark = Color(0xFF003D52);

  // Secondary Palette
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryLight = Color(0xFFFF8E8E);
  static const Color secondaryDark = Color(0xFFE04949);

  // Neutrals
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textDisabled = Color(0xFFA0AEC0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFECC94B);
  static const Color error = Color(0xFFF56565);
  static const Color info = Color(0xFF4299E1);

  // Event Category Colors (Similar to React Native example)
  static const List<Color> eventColors = [
    Color(0xFF1565C0), // Blue
    Color(0xFFEF6C00), // Orange
    Color(0xFF7B1FA2), // Purple
    Color(0xFF2E7D32), // Green
    Color(0xFFC62828), // Red
    Color(0xFF00838F), // Cyan
    Color(0xFF4527A0), // Deep Purple
    Color(0xFFAD1457), // Pink
  ];

  static const List<Color> eventBackgrounds = [
    Color(0xFFE3F2FD),
    Color(0xFFFFF3E0),
    Color(0xFFF3E5F5),
    Color(0xFFE8F5E9),
    Color(0xFFFFEBEE),
    Color(0xFFE0F7FA),
    Color(0xFFEDE7F6),
    Color(0xFFFCE4EC),
  ];

  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E0);
  static const Color borderDark = Color(0xFFA0AEC0);

  // Shadow Color
  static const Color shadow = Color(0x1A000000);
}

/// Text Styles
class AppTextStyles {
  static const String fontFamily = 'Poppins'; // Change if you add custom font

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Special
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );
}

/// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius
class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double full = 999.0;
}
