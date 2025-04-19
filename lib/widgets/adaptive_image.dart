import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptiveImage extends StatelessWidget {
  final String path;
  final BoxFit? fit;

  const AdaptiveImage({
    super.key,
    required this.path,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // For web, convert the file path to a network URL
      // This assumes your files are served from a web server
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } else {
      // For mobile/desktop platforms
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey,
        ),
      ),
    );
  }
} 