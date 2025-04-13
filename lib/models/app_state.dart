import 'package:flutter/foundation.dart';
import 'package:repfiles/models/reptile.dart';

class AppState extends ChangeNotifier {
  int _totalAnimals = 0;
  int _activeBreedingProjects = 0;
  int _todaysTasks = 0;
  List<Reptile> _reptiles = [];
  bool _isLoading = false;
  String? _error;

  // List to store animals
  final List<dynamic> _animals = [];
  List<dynamic> get animals => List.unmodifiable(_animals);

  int get totalAnimals => _totalAnimals;
  int get activeBreedingProjects => _activeBreedingProjects;
  int get todaysTasks => _todaysTasks;
  List<Reptile> get reptiles => _reptiles;
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
      _reptiles = []; // Replace with actual data
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReptile(Reptile reptile) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to add reptile
      await Future.delayed(const Duration(seconds: 1));
      _reptiles.add(reptile);
    } catch (e) {
      _error = e.toString();
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
} 