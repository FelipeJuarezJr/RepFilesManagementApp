import 'package:flutter/material.dart';
import 'package:repfiles/screens/home_screen.dart';
import 'package:repfiles/screens/dashboard_screen.dart';
import 'package:repfiles/screens/animals_screen.dart';
import 'package:repfiles/screens/breeding_screen.dart';
import 'package:repfiles/screens/calculator_screen.dart';
import 'package:repfiles/screens/schedule_screen.dart';
import 'package:repfiles/screens/food_supply_screen.dart';
import 'package:repfiles/screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String animals = '/animals';
  static const String breeding = '/breeding';
  static const String calculator = '/calculator';
  static const String schedule = '/schedule';
  static const String foodSupply = '/food-supply';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    dashboard: (context) => const DashboardScreen(),
    animals: (context) => const AnimalsScreen(),
    breeding: (context) => const BreedingScreen(),
    calculator: (context) => const CalculatorScreen(),
    schedule: (context) => const ScheduleScreen(),
    foodSupply: (context) => const FoodSupplyScreen(),
    settings: (context) => const SettingsScreen(),
  };
} 