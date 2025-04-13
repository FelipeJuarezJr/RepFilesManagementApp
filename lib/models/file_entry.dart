class FileEntry {
  final String reptileName;
  final DateTime date;
  final String path;
  final String fileName;
  final String? description;

  FileEntry({
    required this.reptileName,
    required this.date,
    required this.path,
    required this.fileName,
    this.description,
  });
} 