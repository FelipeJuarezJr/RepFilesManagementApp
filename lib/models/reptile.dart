class Reptile {
  final String id;
  final String name;
  final String species;
  final DateTime dateOfBirth;
  final String sex;
  final double weight;
  final String notes;

  Reptile({
    required this.id,
    required this.name,
    required this.species,
    required this.dateOfBirth,
    required this.sex,
    this.weight = 0.0,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'species': species,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'sex': sex,
    'weight': weight,
    'notes': notes,
  };

  factory Reptile.fromJson(Map<String, dynamic> json) => Reptile(
    id: json['id'],
    name: json['name'],
    species: json['species'],
    dateOfBirth: DateTime.parse(json['dateOfBirth']),
    sex: json['sex'],
    weight: json['weight']?.toDouble() ?? 0.0,
    notes: json['notes'] ?? '',
  );
} 