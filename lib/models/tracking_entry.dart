class TrackingEntry {
  final String reptileName;
  final DateTime date;
  final List<String> activities;
  final String? remarks;

  TrackingEntry({
    required this.reptileName,
    required this.date,
    required this.activities,
    this.remarks,
  });
} 