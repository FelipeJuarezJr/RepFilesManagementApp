import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reptile.dart';
import 'tracking_entry.dart';
import 'note_entry.dart';
import 'feeding_entry.dart';
import 'history_entry.dart';
import 'photo_entry.dart';
import 'file_entry.dart';

class AppState extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int _totalAnimals = 0;
  int _activeBreedingProjects = 0;
  int _todaysTasks = 0;
  List<Reptile> _reptiles = [];
  final List<TrackingEntry> _trackingEntries = [];
  final List<NoteEntry> _noteEntries = [];
  final List<FeedingEntry> _feedingEntries = [];
  final List<HistoryEntry> _historyEntries = [];
  final List<PhotoEntry> _photoEntries = [];
  final List<FileEntry> _fileEntries = [];
  bool _isLoading = false;
  String? _error;

  // List to store animals
  final List<dynamic> _animals = [];
  List<dynamic> get animals => List.unmodifiable(_animals);

  int get totalAnimals => _totalAnimals;
  int get activeBreedingProjects => _activeBreedingProjects;
  int get todaysTasks => _todaysTasks;
  List<Reptile> get reptiles => _reptiles;
  List<TrackingEntry> get trackingEntries => List.unmodifiable(_trackingEntries);
  List<NoteEntry> get noteEntries => List.unmodifiable(_noteEntries);
  List<FeedingEntry> get feedingEntries => List.unmodifiable(_feedingEntries);
  List<HistoryEntry> get historyEntries => List.unmodifiable(_historyEntries);
  List<PhotoEntry> get photoEntries => List.unmodifiable(_photoEntries);
  List<FileEntry> get fileEntries => List.unmodifiable(_fileEntries);
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
      final snapshot = await _db.collection('reptiles').get();
      _reptiles = snapshot.docs
          .map((doc) => Reptile.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      _error = 'Failed to load reptiles: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReptile(Reptile reptile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final docRef = await _db.collection('reptiles').add(reptile.toMap());
      final newReptile = reptile.copyWith(id: docRef.id);
      _reptiles.add(newReptile);
    } catch (e) {
      _error = 'Failed to add reptile: $e';
    } finally {
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
    _trackingEntries.removeWhere((entry) => entry.reptileName == reptile.name);
    _noteEntries.removeWhere((note) => note.reptileName == reptile.name);
    _feedingEntries.removeWhere((entry) => entry.reptileName == reptile.name);
    _historyEntries.removeWhere((entry) => entry.reptileName == reptile.name);
    _photoEntries.removeWhere((entry) => entry.reptileName == reptile.name);
    _fileEntries.removeWhere((entry) => entry.reptileName == reptile.name);
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
    return _reptiles.any((reptile) => 
      reptile.name == reptileName && reptile.notes.isNotEmpty
    );
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

  // Feeding methods
  void addFeeding(FeedingEntry entry) {
    _feedingEntries.add(entry);
    notifyListeners();
  }

  List<FeedingEntry> getFeedingsForReptile(String reptileName) {
    return _feedingEntries
        .where((entry) => entry.reptileName == reptileName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // History methods
  void addHistory(HistoryEntry entry) {
    _historyEntries.add(entry);
    notifyListeners();
  }

  List<HistoryEntry> getHistoryForReptile(String reptileName) {
    return _historyEntries
        .where((entry) => entry.reptileName == reptileName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Photo methods
  Future<void> addPhoto(PhotoEntry entry) async {
    _photoEntries.add(entry);
    notifyListeners();
  }

  List<PhotoEntry> getPhotosForReptile(String reptileName) {
    return _photoEntries
        .where((entry) => entry.reptileName == reptileName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // File methods
  Future<void> addFile(FileEntry entry) async {
    _fileEntries.add(entry);
    notifyListeners();
  }

  List<FileEntry> getFilesForReptile(String reptileName) {
    return _fileEntries
        .where((entry) => entry.reptileName == reptileName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Delete methods
  void deleteFeeding(FeedingEntry entry) {
    _feedingEntries.remove(entry);
    notifyListeners();
  }

  void deleteHistory(HistoryEntry entry) {
    _historyEntries.remove(entry);
    notifyListeners();
  }

  void deletePhoto(PhotoEntry entry) {
    _photoEntries.remove(entry);
    notifyListeners();
  }

  void deleteFile(FileEntry entry) {
    _fileEntries.remove(entry);
    notifyListeners();
  }
} 