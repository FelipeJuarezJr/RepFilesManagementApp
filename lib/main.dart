import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/animals_screen.dart';
import 'screens/breeding_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/food_supply_screen.dart';
import 'screens/settings_screen.dart';
import 'styles/app_theme.dart';
import 'models/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepFiles',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/animals': (context) => const AnimalsScreen(),
        '/breeding': (context) => const BreedingScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/food-supply': (context) => const FoodSupplyScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
} 