import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/common/attachment_card.dart';
import 'dart:io';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  Future<void> _deleteEvent(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await context.read<EventProvider>().deleteEvent(event.id);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.eventBackgrounds[event.colorIndex];
    final accentColor = AppColors.eventColors[event.colorIndex];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: backgroundColor,
            foregroundColor: accentColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.title,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      backgroundColor,
                      accentColor.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.event,
                    size: 80,
                    color: accentColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.eventForm,
                    arguments: {'event': event},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteEvent(context),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time Card
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: 'Date & Time',
                    children: [
                      _buildInfoRow(
                        'Date',
                        DateFormat('EEEE, MMMM dd, yyyy').format(event.date),
                      ),
                      if (event.isAllDay)
                        _buildInfoRow('Time', 'All Day')
                      else ...[
                        if (event.startTime != null)
                          _buildInfoRow(
                            'Start',
                            DateFormat('hh:mm a').format(event.startTime!),
                          ),
                        if (event.endTime != null)
                          _buildInfoRow(
                            'End',
                            DateFormat('hh:mm a').format(event.endTime!),
                          ),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Category
                  if (event.category != null) ...[
                    _buildInfoCard(
                      icon: Icons.category,
                      title: 'Category',
                      children: [
                        Chip(
                          label: Text(event.category!),
                          backgroundColor: backgroundColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Location
                  if (event.location != null) ...[
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Location',
                      children: [
                        Text(event.location!, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Description
                  if (event.description != null) ...[
                    _buildInfoCard(
                      icon: Icons.description,
                      title: 'Description',
                      children: [
                        Text(event.description!, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Notes
                  if (event.notes != null) ...[
                    _buildInfoCard(
                      icon: Icons.notes,
                      title: 'Notes',
                      children: [
                        Text(event.notes!, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Attachments
                  if (event.attachments != null && event.attachments!.isNotEmpty) ...[
                    _buildInfoCard(
                      icon: Icons.attach_file,
                      title: 'Attachments (${event.attachments!.length})',
                      children: event.attachments!.map((attachment) {
                        return AttachmentCard(
                          attachment: attachment,
                          readOnly: true,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Metadata
                  _buildInfoCard(
                    icon: Icons.info_outline,
                    title: 'Details',
                    children: [
                      _buildInfoRow(
                        'Created',
                        DateFormat('MMM dd, yyyy • hh:mm a').format(event.createdAt),
                      ),
                      _buildInfoRow(
                        'Last Updated',
                        DateFormat('MMM dd, yyyy • hh:mm a').format(event.updatedAt),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: AppTextStyles.h4),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
