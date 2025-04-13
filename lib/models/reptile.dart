class Reptile {
  final String name;
  final String? identifier;
  final String? group;
  final String sex;
  final String? morph;
  final double? length;
  final String lengthUnit;
  final double? weight;
  final String weightUnit;
  final DateTime dateOfBirth;
  final String? breeder;
  final String? remarks;
  final String species;

  Reptile({
    required this.name,
    this.identifier,
    this.group,
    this.sex = 'Unknown',
    this.morph,
    this.length,
    this.lengthUnit = 'cm',
    this.weight,
    this.weightUnit = 'gr',
    required this.dateOfBirth,
    this.breeder,
    this.remarks,
    required this.species,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'identifier': identifier,
    'group': group,
    'sex': sex,
    'morph': morph,
    'length': length,
    'lengthUnit': lengthUnit,
    'weight': weight,
    'weightUnit': weightUnit,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'breeder': breeder,
    'remarks': remarks,
    'species': species,
  };

  factory Reptile.fromJson(Map<String, dynamic> json) => Reptile(
    name: json['name'],
    identifier: json['identifier'],
    group: json['group'],
    sex: json['sex'],
    morph: json['morph'],
    length: json['length']?.toDouble(),
    lengthUnit: json['lengthUnit'] ?? 'cm',
    weight: json['weight']?.toDouble(),
    weightUnit: json['weightUnit'] ?? 'gr',
    dateOfBirth: DateTime.parse(json['dateOfBirth']),
    breeder: json['breeder'],
    remarks: json['remarks'],
    species: json['species'],
  );
} 