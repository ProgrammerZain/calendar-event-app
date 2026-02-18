import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../models/attachment_model.dart';
import '../services/file_service.dart';
import '../config/constants.dart';
import '../widgets/common/attachment_picker_bottom_sheet.dart';
import '../widgets/common/attachment_card.dart';

class EventFormScreen extends StatefulWidget {
  final EventModel? event;
  final DateTime? initialDate;

  const EventFormScreen({
    super.key,
    this.event,
    this.initialDate,
  });

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _categoryController = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isAllDay = false;
  int _selectedColorIndex = 0;
  List<AttachmentModel> _attachments = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.event != null) {
      // Edit mode
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description ?? '';
      _locationController.text = widget.event!.location ?? '';
      _notesController.text = widget.event!.notes ?? '';
      _categoryController.text = widget.event!.category ?? '';
      _selectedDate = widget.event!.date;
      _selectedColorIndex = widget.event!.colorIndex;
      _isAllDay = widget.event!.isAllDay;
      _attachments = List.from(widget.event!.attachments ?? []);

      if (widget.event!.startTime != null) {
        _startTime = TimeOfDay.fromDateTime(widget.event!.startTime!);
      }
      if (widget.event!.endTime != null) {
        _endTime = TimeOfDay.fromDateTime(widget.event!.endTime!);
      }
    } else {
      // Add mode
      _selectedDate = widget.initialDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final eventProvider = context.read<EventProvider>();

      DateTime? startDateTime;
      DateTime? endDateTime;

      if (!_isAllDay && _startTime != null) {
        startDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _startTime!.hour,
          _startTime!.minute,
        );
      }

      if (!_isAllDay && _endTime != null) {
        endDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }

      if (widget.event != null) {
        // Update existing event
        final updatedEvent = widget.event!.copyWith(
          title: _titleController.text.trim(),
          date: _selectedDate,
          startTime: startDateTime,
          endTime: endDateTime,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          attachments: _attachments.isEmpty ? null : _attachments,
          colorIndex: _selectedColorIndex,
          isAllDay: _isAllDay,
          category: _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

        await eventProvider.updateEvent(updatedEvent);
      } else {
        // Create new event
        await eventProvider.addEvent(
          title: _titleController.text.trim(),
          date: _selectedDate,
          startTime: startDateTime,
          endTime: endDateTime,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          attachments: _attachments.isEmpty ? null : _attachments,
          colorIndex: _selectedColorIndex,
          isAllDay: _isAllDay,
          category: _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.event != null
                ? 'Event updated successfully'
                : 'Event created successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _showAttachmentPicker() async {
    final result = await showModalBottomSheet<AttachmentModel>(
      context: context,
      builder: (context) => const AttachmentPickerBottomSheet(),
    );

    if (result != null) {
      setState(() {
        _attachments.add(result);
      });
    }
  }

  void _removeAttachment(AttachmentModel attachment) {
    setState(() {
      _attachments.remove(attachment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'New Event'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveEvent,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'Enter event title',
                  prefixIcon: Icon(Icons.event),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Category Field
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (Optional)',
                  hintText: 'e.g., Work, Personal, Birthday',
                  prefixIcon: Icon(Icons.category),
                ),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppSpacing.md),

              // Date Picker
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // All Day Toggle
              SwitchListTile(
                title: const Text('All Day Event'),
                value: _isAllDay,
                onChanged: (value) {
                  setState(() {
                    _isAllDay = value;
                    if (value) {
                      _startTime = null;
                      _endTime = null;
                    }
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),

              // Time Pickers (only if not all day)
              if (!_isAllDay) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectStartTime,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _startTime?.format(context) ?? 'Select time',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: InkWell(
                        onTap: _selectEndTime,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _endTime?.format(context) ?? 'Select time',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              // Location Field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  hintText: 'Add location',
                  prefixIcon: Icon(Icons.location_on),
                ),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppSpacing.md),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add description',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.newline,
              ),

              const SizedBox(height: AppSpacing.md),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add notes',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Color Picker
              const Text('Event Color', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppColors.eventColors.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedColorIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.only(right: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.eventBackgrounds[index],
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.eventColors[index]
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.eventColors[index],
                              shape: BoxShape.circle,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Attachments Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Attachments', style: AppTextStyles.h4),
                  OutlinedButton.icon(
                    onPressed: _showAttachmentPicker,
                    icon: const Icon(Icons.attach_file, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),

              if (_attachments.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                ..._attachments.map((attachment) {
                  return AttachmentCard(
                    attachment: attachment,
                    onDelete: () => _removeAttachment(attachment),
                  );
                }).toList(),
              ],

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
