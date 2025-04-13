import 'package:flutter/foundation.dart';
import 'reptile.dart';
import 'tracking_entry.dart';
import 'note_entry.dart';

class AppState extends ChangeNotifier {
  int _totalAnimals = 0;
  int _activeBreedingProjects = 0;
  int _todaysTasks = 0;
  final List<Reptile> _reptiles = [];
  final List<TrackingEntry> _trackingEntries = [];
  final List<NoteEntry> _noteEntries = [];
  bool _isLoading = false;
  String? _error;

  // List to store animals
  final List<dynamic> _animals = [];
  List<dynamic> get animals => List.unmodifiable(_animals);

  int get totalAnimals => _totalAnimals;
  int get activeBreedingProjects => _activeBreedingProjects;
  int get todaysTasks => _todaysTasks;
  List<Reptile> get reptiles => List.unmodifiable(_reptiles);
  List<TrackingEntry> get trackingEntries => List.unmodifiable(_trackingEntries);
  List<NoteEntry> get noteEntries => List.unmodifiable(_noteEntries);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateTotalAnimals(int count) {
    _totalAnimals = count;
    notifyListeners();
  }

  void updateBreedingProjects(int count) {
    _activeBreedingProjects = count;
    notifyListeners();
  }

  void updateTodaysTasks(int count) {
    _todaysTasks = count;
    notifyListeners();
  }

  Future<void> loadReptiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to load reptiles
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      _reptiles.clear(); // Replace with actual data
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReptile(Reptile reptile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      _reptiles.add(reptile);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to add an animal
  void addAnimal(dynamic animal) {
    _animals.add(animal);
    notifyListeners();
  }

  // Method to remove an animal
  void removeAnimal(dynamic animal) {
    _animals.remove(animal);
    notifyListeners();
  }

  // Remove a reptile
  void removeReptile(Reptile reptile) {
    _reptiles.remove(reptile);
    // Also remove associated tracking entries
    _trackingEntries.removeWhere((entry) => entry.reptileName == reptile.name);
    _noteEntries.removeWhere((note) => note.reptileName == reptile.name);
    notifyListeners();
  }

  // Add tracking entry
  void addTrackingEntry(TrackingEntry entry) {
    _trackingEntries.add(entry);
    notifyListeners();
  }

  // Get tracking entries for a specific reptile
  List<TrackingEntry> getTrackingEntriesForReptile(String reptileName) {
    return _trackingEntries
        .where((entry) => entry.reptileName == reptileName)
        .toList();
  }

  // Note management methods
  void addNote(NoteEntry note) {
    _noteEntries.add(note);
    notifyListeners();
  }

  bool hasNotes(String reptileName) {
    return _noteEntries.any((note) => note.reptileName == reptileName);
  }

  List<NoteEntry> getNotesForReptile(String reptileName) {
    return _noteEntries
        .where((note) => note.reptileName == reptileName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
  }

  void deleteNote(NoteEntry note) {
    _noteEntries.remove(note);
    notifyListeners();
  }
} 