import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/attachment_model.dart';
import '../config/constants.dart';

class FileService {
  static const _uuid = Uuid();

  /// Pick image from gallery
  static Future<AttachmentModel?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      
      // Validate file size
      if (file.size > AppConstants.maxFileSize) {
        throw Exception('File size exceeds ${AppConstants.maxFileSize ~/ (1024 * 1024)}MB');
      }

      // Save file to app directory
      final savedPath = await _saveFile(File(file.path!), file.name);

      return AttachmentModel(
        id: _uuid.v4(),
        fileName: file.name,
        filePath: savedPath,
        fileType: 'image',
        fileSize: file.size,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick PDF document
  static Future<AttachmentModel?> pickPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;

      if (file.size > AppConstants.maxFileSize) {
        throw Exception('File size exceeds ${AppConstants.maxFileSize ~/ (1024 * 1024)}MB');
      }

      final savedPath = await _saveFile(File(file.path!), file.name);

      return AttachmentModel(
        id: _uuid.v4(),
        fileName: file.name,
        filePath: savedPath,
        fileType: 'pdf',
        fileSize: file.size,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to pick PDF: $e');
    }
  }

  /// Pick any document
  static Future<AttachmentModel?> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...AppConstants.allowedDocExtensions],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;

      if (file.size > AppConstants.maxFileSize) {
        throw Exception('File size exceeds ${AppConstants.maxFileSize ~/ (1024 * 1024)}MB');
      }

      final savedPath = await _saveFile(File(file.path!), file.name);

      return AttachmentModel(
        id: _uuid.v4(),
        fileName: file.name,
        filePath: savedPath,
        fileType: 'document',
        fileSize: file.size,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to pick document: $e');
    }
  }

  /// Save file to app directory
  static Future<String> _saveFile(File file, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory('${appDir.path}/attachments');

    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }

    final newFileName = '${_uuid.v4()}_$fileName';
    final newPath = path.join(attachmentsDir.path, newFileName);
    
    await file.copy(newPath);
    return newPath;
  }

  /// Delete file
  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Get file extension
  static String getFileExtension(String fileName) {
    return path.extension(fileName).toLowerCase().replaceAll('.', '');
  }

  /// Check if file is image
  static bool isImageFile(String fileName) {
    final ext = getFileExtension(fileName);
    return AppConstants.allowedImageExtensions.contains(ext);
  }

  /// Check if file is PDF
  static bool isPDFFile(String fileName) {
    final ext = getFileExtension(fileName);
    return ext == 'pdf';
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
