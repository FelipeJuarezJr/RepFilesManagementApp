import 'package:cloud_firestore/cloud_firestore.dart';

class Reptile {
  final String id;
  final String name;
  final String species;
  final String morph;
  final DateTime dateOfBirth;
  final DateTime dateAcquired;
  final double weight;
  final String weightUnit;
  final double length;
  final String lengthUnit;
  final String gender;
  final String identifier;
  final String notes;

  Reptile({
    required this.id,
    required this.name,
    required this.species,
    required this.morph,
    required this.dateOfBirth,
    required this.dateAcquired,
    required this.weight,
    this.weightUnit = 'grams',
    required this.length,
    this.lengthUnit = 'cm',
    required this.gender,
    required this.identifier,
    this.notes = '',
  });

  factory Reptile.fromMap(Map<String, dynamic> data, String id) {
    return Reptile(
      id: id,
      name: data['name'] ?? '',
      species: data['species'] ?? '',
      morph: data['morph'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      dateAcquired: (data['dateAcquired'] as Timestamp).toDate(),
      weight: (data['weight'] ?? 0).toDouble(),
      weightUnit: data['weightUnit'] ?? 'grams',
      length: (data['length'] ?? 0).toDouble(),
      lengthUnit: data['lengthUnit'] ?? 'cm',
      gender: data['gender'] ?? '',
      identifier: data['identifier'] ?? '',
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'species': species,
      'morph': morph,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'dateAcquired': Timestamp.fromDate(dateAcquired),
      'weight': weight,
      'weightUnit': weightUnit,
      'length': length,
      'lengthUnit': lengthUnit,
      'gender': gender,
      'identifier': identifier,
      'notes': notes,
    };
  }

  Reptile copyWith({
    String? id,
    String? name,
    String? species,
    String? morph,
    DateTime? dateOfBirth,
    DateTime? dateAcquired,
    double? weight,
    String? weightUnit,
    double? length,
    String? lengthUnit,
    String? gender,
    String? identifier,
    String? notes,
  }) {
    return Reptile(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      morph: morph ?? this.morph,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateAcquired: dateAcquired ?? this.dateAcquired,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      length: length ?? this.length,
      lengthUnit: lengthUnit ?? this.lengthUnit,
      gender: gender ?? this.gender,
      identifier: identifier ?? this.identifier,
      notes: notes ?? this.notes,
    );
  }

  String get sex => gender;
} 