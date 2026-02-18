import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'attachment_model.g.dart';

@HiveType(typeId: 1)
class AttachmentModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fileName;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final String fileType; // 'image' or 'pdf' or 'document'

  @HiveField(4)
  final int fileSize; // in bytes

  @HiveField(5)
  final DateTime uploadedAt;

  const AttachmentModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'filePath': filePath,
        'fileType': fileType,
        'fileSize': fileSize,
        'uploadedAt': uploadedAt.toIso8601String(),
      };

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, fileName, filePath, fileType, fileSize, uploadedAt];
}
