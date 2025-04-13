import 'package:file_picker/file_picker.dart';

class FileUtils {
  static const List<String> allowedImageExtensions = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];

  static const List<String> allowedFileExtensions = [
    'pdf', 'doc', 'docx', 'txt', 'csv',
    'xls', 'xlsx', 'jpg', 'jpeg', 'png',
    'gif', 'webp'
  ];

  static Future<FilePickerResult?> pickFile({bool photoOnly = false}) async {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: photoOnly ? allowedImageExtensions : allowedFileExtensions,
    );
  }

  static bool isValidFileType(String fileName, {bool photoOnly = false}) {
    final extension = fileName.split('.').last.toLowerCase();
    return photoOnly
        ? allowedImageExtensions.contains(extension)
        : allowedFileExtensions.contains(extension);
  }
} 