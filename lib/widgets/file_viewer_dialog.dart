import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../models/file_entry.dart';
import '../models/photo_entry.dart';

class FileViewerDialog extends StatelessWidget {
  final dynamic entry; // Can be FileEntry or PhotoEntry
  final Function() onDelete;

  const FileViewerDialog({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  bool get isPhoto => entry is PhotoEntry;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isPhoto ? 'View Photo' : 'View File',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareFile(context),
                    tooltip: 'Share',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context),
                    tooltip: 'Delete',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPhoto)
                        Image.file(
                          File(entry.path),
                          fit: BoxFit.contain,
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.file_present),
                          title: Text(entry.fileName),
                          subtitle: Text(entry.description ?? ''),
                          onTap: () => OpenFile.open(entry.path),
                        ),
                      if (entry.description != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Description:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(entry.description!),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        'Added on: ${_formatDate(entry.date)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  Future<void> _shareFile(BuildContext context) async {
    try {
      await Share.shareXFiles(
        [XFile(entry.path)],
        text: entry.description,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${isPhoto ? 'Photo' : 'File'}'),
        content: Text(
          'Are you sure you want to delete this ${isPhoto ? 'photo' : 'file'}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close viewer dialog
              onDelete();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 