import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'attachment_model.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final DateTime? startTime;

  @HiveField(4)
  final DateTime? endTime;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  final List<AttachmentModel>? attachments;

  @HiveField(8)
  final int colorIndex;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final bool isAllDay;

  @HiveField(12)
  final String? category;

  @HiveField(13)
  final String? notes;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.description,
    this.location,
    this.attachments,
    this.colorIndex = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isAllDay = false,
    this.category,
    this.notes,
  });

  EventModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? location,
    List<AttachmentModel>? attachments,
    int? colorIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAllDay,
    String? category,
    String? notes,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAllDay: isAllDay ?? this.isAllDay,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'description': description,
        'location': location,
        'attachments': attachments?.map((a) => a.toJson()).toList(),
        'colorIndex': colorIndex,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isAllDay': isAllDay,
        'category': category,
        'notes': notes,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        startTime,
        endTime,
        description,
        location,
        attachments,
        colorIndex,
        createdAt,
        updatedAt,
        isAllDay,
        category,
        notes,
      ];
}
