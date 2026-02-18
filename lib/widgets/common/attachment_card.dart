import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/attachment_model.dart';
import '../../services/file_service.dart';
import '../../config/constants.dart';
import 'package:open_file/open_file.dart';

class AttachmentCard extends StatelessWidget {
  final AttachmentModel attachment;
  final VoidCallback? onDelete;
  final bool readOnly;

  const AttachmentCard({
    super.key,
    required this.attachment,
    this.onDelete,
    this.readOnly = false,
  });

  Future<void> _openFile() async {
    try {
      await OpenFile.open(attachment.filePath);
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

  IconData _getFileIcon() {
    if (FileService.isImageFile(attachment.fileName)) {
      return Icons.image;
    } else if (FileService.isPDFFile(attachment.fileName)) {
      return Icons.picture_as_pdf;
    }
    return Icons.insert_drive_file;
  }

  Color _getFileColor() {
    if (FileService.isImageFile(attachment.fileName)) {
      return AppColors.eventColors[0]; // Blue
    } else if (FileService.isPDFFile(attachment.fileName)) {
      return AppColors.error;
    }
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final fileExists = File(attachment.filePath).existsSync();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getFileColor().withOpacity(0.1),
          child: Icon(_getFileIcon(), color: _getFileColor()),
        ),
        title: Text(
          attachment.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          FileService.formatFileSize(attachment.fileSize),
          style: AppTextStyles.caption,
        ),
        trailing: readOnly
            ? (fileExists
                ? IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: _openFile,
                  )
                : const Icon(Icons.error_outline, color: AppColors.error))
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDelete,
              ),
        onTap: fileExists ? _openFile : null,
      ),
    );
  }
}
