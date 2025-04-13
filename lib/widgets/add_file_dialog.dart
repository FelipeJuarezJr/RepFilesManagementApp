import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/app_state.dart';
import '../models/file_entry.dart';
import '../models/photo_entry.dart';
import '../utils/file_utils.dart';

class AddFileDialog extends StatefulWidget {
  final String reptileName;
  final bool isPhoto;

  const AddFileDialog({
    super.key,
    required this.reptileName,
    this.isPhoto = false,
  });

  @override
  State<AddFileDialog> createState() => _AddFileDialogState();
}

class _AddFileDialogState extends State<AddFileDialog> {
  File? _selectedFile;
  final _descriptionController = TextEditingController();
  bool _isSaving = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    widget.isPhoto ? 'Add Photo' : 'Add File',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    tooltip: 'Cancel',
                  ),
                  IconButton(
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    onPressed: _isSaving ? null : _saveFile,
                    tooltip: 'Save',
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Body
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Selection
                  if (_selectedFile != null) ...[
                    if (widget.isPhoto)
                      Image.file(
                        _selectedFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else
                      ListTile(
                        leading: const Icon(Icons.file_present),
                        title: Text(_selectedFile!.path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedFile = null;
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],

                  // Upload Button
                  if (_selectedFile == null)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: Icon(widget.isPhoto ? Icons.photo_camera : Icons.upload_file),
                        label: Text(widget.isPhoto ? 'Select Photo' : 'Select File'),
                      ),
                    ),

                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Description
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                    enabled: !_isSaving,
                  ),
                ],
              ),
            ),

            // Footer
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectedFile != null && !_isSaving ? _saveFile : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      if (widget.isPhoto) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (pickedFile != null) {
          setState(() {
            _selectedFile = File(pickedFile.path);
            _error = null;
          });
        }
      } else {
        final result = await FileUtils.pickFile();
        if (result != null) {
          final file = File(result.files.single.path!);
          if (!FileUtils.isValidFileType(file.path)) {
            setState(() {
              _error = 'Invalid file type. Allowed types: ${FileUtils.allowedFileExtensions.join(", ")}';
            });
            return;
          }
          setState(() {
            _selectedFile = file;
            _error = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Error selecting file: $e';
      });
    }
  }

  Future<void> _saveFile() async {
    if (_selectedFile == null) {
      setState(() {
        _error = 'Please select a file';
      });
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Get the app's document directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = _selectedFile!.path.split('/').last;
      final savedFile = await _selectedFile!.copy('${appDir.path}/$fileName');

      if (widget.isPhoto) {
        final photo = PhotoEntry(
          reptileName: widget.reptileName,
          date: DateTime.now(),
          path: savedFile.path,
          description: _descriptionController.text.trim(),
        );
        await context.read<AppState>().addPhoto(photo);
      } else {
        final file = FileEntry(
          reptileName: widget.reptileName,
          date: DateTime.now(),
          path: savedFile.path,
          fileName: fileName,
          description: _descriptionController.text.trim(),
        );
        await context.read<AppState>().addFile(file);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isPhoto ? 'Photo uploaded successfully' : 'File uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Error saving file: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
} 