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
  final String gender;

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
    required this.gender,
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
    'gender': gender,
  };

  factory Reptile.fromJson(Map<String, dynamic> json) => Reptile(
    name: json['name'],
    identifier: json['identifier'],
    group: json['group'],
    sex: json['sex'],
    morph: json['morph'],
    length: json['length']?.toDouble() ?? 0.0,
    lengthUnit: json['lengthUnit'] ?? 'cm',
    weight: json['weight']?.toDouble() ?? 0.0,
    weightUnit: json['weightUnit'] ?? 'gr',
    dateOfBirth: DateTime.parse(json['dateOfBirth']),
    breeder: json['breeder'],
    remarks: json['remarks'],
    species: json['species'],
    gender: json['gender'],
  );
} 