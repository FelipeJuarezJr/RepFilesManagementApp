class FeedingEntry {
  final String reptileName;
  final DateTime date;
  final String foodType;
  final int quantity;
  final String? notes;

  FeedingEntry({
    required this.reptileName,
    required this.date,
    required this.foodType,
    required this.quantity,
    this.notes,
  });
} 