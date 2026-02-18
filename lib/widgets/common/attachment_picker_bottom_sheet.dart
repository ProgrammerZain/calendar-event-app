import 'package:flutter/material.dart';
import '../../services/file_service.dart';
import '../../models/attachment_model.dart';
import '../../config/constants.dart';

class AttachmentPickerBottomSheet extends StatelessWidget {
  const AttachmentPickerBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context) async {
    try {
      final attachment = await FileService.pickImage();
      if (context.mounted && attachment != null) {
        Navigator.pop(context, attachment);
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

  Future<void> _pickPDF(BuildContext context) async {
    try {
      final attachment = await FileService.pickPDF();
      if (context.mounted && attachment != null) {
        Navigator.pop(context, attachment);
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

  Future<void> _pickDocument(BuildContext context) async {
    try {
      final attachment = await FileService.pickDocument();
      if (context.mounted && attachment != null) {
        Navigator.pop(context, attachment);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Add Attachment', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.lg),
          
          ListTile(
            leading: const Icon(Icons.image, color: AppColors.primary),
            title: const Text('Pick Image'),
            subtitle: const Text('JPG, PNG, GIF'),
            onTap: () => _pickImage(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: AppColors.error),
            title: const Text('Pick PDF'),
            subtitle: const Text('PDF documents'),
            onTap: () => _pickPDF(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.insert_drive_file, color: AppColors.secondary),
            title: const Text('Pick Document'),
            subtitle: const Text('DOC, DOCX, PDF'),
            onTap: () => _pickDocument(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
