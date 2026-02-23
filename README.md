# 📅 Calendar Event App

A beautiful, production-ready calendar application built with Flutter. Manage your events with style - completely offline, no backend required.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue" alt="Platform">
  <img src="https://img.shields.io/badge/Version-1.0.0-success" alt="Version">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

---

## ✨ Features

### 📆 **Multiple Calendar Views**
- **Month View** - Classic calendar grid with event indicators
- **Week View** - 7-day horizontal scroll with event cards
- **Day View** - Timeline schedule with hour slots (6 AM - 10 PM)
- **Timeline View** - Chronological list of all events

### 🎯 **Event Management**
- ➕ Create events with title, date, time, location, category
- ✏️ Edit existing events
- 🗑️ Delete events with confirmation
- 📝 Add detailed descriptions and notes
- ⏰ Set all-day events or timed events
- 🎨 Choose from 8 color themes per event

### 📎 **Attachments**
- Upload images (JPG, PNG, GIF)
- Upload PDF documents
- Upload other documents (DOC, DOCX)
- Preview attachments inline
- File size limit: 10MB per file
- Multiple attachments per event

### 🎨 **Theming**
- 🌞 Light mode
- 🌙 Dark mode
- 🔄 System theme (follows device settings)
- Material Design 3
- Custom color schemes

### 💾 **Local Storage**
- Zero backend dependencies
- Offline-first architecture
- Fast local database (Hive)
- Persistent event data
- File storage in app directory

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK:** `^3.11.0`
- **Dart SDK:** `^3.11.0`
- **iOS:** 12.0+
- **Android:** API 21+ (Android 5.0)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ProgrammerZain/calendar-event-app.git
   cd calendar-event-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # List available devices
   flutter devices
   
   # Run on connected device
   flutter run
   
   # Run on specific device
   flutter run -d <device-id>
   ```

---

## 🏗️ Project Structure

```
lib/
├── config/
│   ├── constants.dart          # App-wide constants (colors, spacing, etc.)
│   ├── theme.dart              # Light & dark theme definitions
│   └── routes.dart             # Navigation routes
│
├── models/
│   ├── event_model.dart        # Event data model with Hive adapter
│   └── attachment_model.dart   # Attachment data model
│
├── providers/
│   ├── event_provider.dart     # Event state management
│   ├── theme_provider.dart     # Theme state management
│   └── calendar_provider.dart  # Calendar view state
│
├── services/
│   ├── storage_service.dart    # Hive database operations
│   └── file_service.dart       # File picking & management
│
├── screens/
│   ├── home_screen.dart        # Main dashboard
│   ├── event_form_screen.dart  # Add/Edit event form
│   └── event_detail_screen.dart # Event details view
│
├── widgets/
│   ├── calendar/               # Calendar view widgets
│   │   ├── month_view.dart
│   │   ├── week_view.dart
│   │   ├── day_view.dart
│   │   └── timeline_view.dart
│   └── common/                 # Reusable widgets
│       ├── custom_app_bar.dart
│       ├── custom_fab.dart
│       ├── attachment_card.dart
│       └── event_list_item.dart
│
├── utils/
│   └── date_utils.dart         # Date formatting utilities
│
└── main.dart                   # App entry point
```

---

## 🛠️ Tech Stack

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter** | SDK | Flutter framework |
| **cupertino_icons** | ^1.0.8 | iOS-style icons |
| **provider** | ^6.1.1 | State management |
| **hive** | ^2.2.3 | NoSQL database |
| **hive_flutter** | ^1.1.0 | Hive Flutter integration |
| **path_provider** | ^2.1.1 | File system paths |
| **table_calendar** | ^3.0.9 | Calendar widget |
| **intl** | ^0.18.1 | Date formatting |
| **file_picker** | ^6.1.1 | File selection |
| **permission_handler** | ^11.1.0 | Permission management |
| **open_file** | ^3.3.2 | Open files with default apps |
| **path** | ^1.8.3 | Path manipulation |
| **flutter_pdfview** | ^1.3.2 | PDF preview |
| **share_plus** | ^7.2.1 | Share functionality |
| **flutter_svg** | ^2.0.9 | SVG rendering |
| **cached_network_image** | ^3.3.0 | Image caching |
| **flutter_staggered_animations** | ^1.1.1 | Staggered animations |
| **uuid** | ^4.2.2 | Unique ID generation |
| **equatable** | ^2.0.5 | Value equality |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_test** | SDK | Testing framework |
| **hive_generator** | ^2.0.1 | Hive type adapters |
| **build_runner** | ^2.4.6 | Code generation |
| **analyzer** | ^6.4.1 | Static analysis |
| **flutter_lints** | ^6.0.0 | Linting rules |

---

## 🎨 Design Philosophy

### Material Design 3
- Modern, clean UI following Google's latest design guidelines
- Adaptive color schemes
- Smooth animations and transitions
- Responsive layouts

### Color Palette
```dart
Primary:   #226278  // Deep teal
Secondary: #FF6B6B  // Coral red
Surface:   #FFFFFF  // Pure white
Background:#F5F7FA  // Light gray
```

### Event Colors
8 predefined color combinations for event categorization:
- 🔵 Blue - Professional events
- 🟠 Orange - Personal tasks
- 🟣 Purple - Creative projects
- 🟢 Green - Health & fitness
- 🔴 Red - Important/urgent
- 🔷 Cyan - Learning & development
- 🟪 Deep Purple - Social events
- 🩷 Pink - Entertainment

---

## 📄 License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2024 Zain Irfan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 👨‍💻 Author

**Zain Irfan**

- 📧 Email: [zainirfan565@gmail.com](mailto:zainirfan565@gmail.com)
- 🐙 GitHub: [@ProgrammerZain](https://github.com/ProgrammerZain)

---

<p align="center">
  Made with ❤️ and Flutter by <a href="https://github.com/ProgrammerZain">Zain Irfan</a>
</p>

<p align="center">
  <a href="#-calendar-event-app">⬆️ Back to Top</a>
</p>
