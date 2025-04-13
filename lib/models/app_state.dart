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
  List<Reptile> get reptiles => List.unmodifiable(_reptiles);
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
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Add API call or database operation here
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
    notifyListeners();
  }
} 