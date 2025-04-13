class PhotoEntry {
  final String reptileName;
  final DateTime date;
  final String path;
  final String? description;

  PhotoEntry({
    required this.reptileName,
    required this.date,
    required this.path,
    this.description,
  });
} 