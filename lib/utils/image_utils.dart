import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ImageUtils {
  static const List<String> supportedImageFormats = [
    'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'heic'
  ];

  static bool isValidImageFormat(String filePath) {
    final extension = path.extension(filePath).toLowerCase().replaceAll('.', '');
    debugPrint('Checking extension: $extension');
    return supportedImageFormats.contains(extension);
  }

  static Future<File?> processImage(File inputFile) async {
    try {
      if (!isValidImageFormat(inputFile.path)) {
        debugPrint('Invalid image format: ${inputFile.path}');
        return null;
      }

      // Get temporary directory for saving the processed image
      final tempDir = await getTemporaryDirectory();
      final extension = path.extension(inputFile.path).toLowerCase();
      final outputPath = path.join(
        tempDir.path,
        'processed_${DateTime.now().millisecondsSinceEpoch}$extension',
      );

      // Copy the file
      final processedFile = await inputFile.copy(outputPath);
      return processedFile;
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  static Future<String?> generateThumbnailPath(String imagePath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = path.join(
        tempDir.path,
        'thumb_${path.basename(imagePath)}',
      );

      // For now, just copy the original file as thumbnail
      await File(imagePath).copy(thumbnailPath);
      return thumbnailPath;
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      return null;
    }
  }
} 