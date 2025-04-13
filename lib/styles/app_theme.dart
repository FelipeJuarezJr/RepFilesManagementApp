import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF009540);  // Blue
  static const Color primaryDark = Color(0xFF1976D2);   // Darker Blue
  static const Color primaryLight = Color(0xFF64B5F6);  // Lighter Blue
  
  // Accent colors
  static const Color accentColor = Color(0xFF4CAF50);   // Green
  static const Color accentDark = Color(0xFF388E3C);    // Darker Green
  static const Color accentLight = Color(0xFF81C784);   // Lighter Green

  // Background colors
  static const Color backgroundColor = Color(0xFFFFFFFF);  // White
  static const Color surfaceColor = Color(0xFFF5F5F5);    // Light Grey
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);     // Dark Grey
  static const Color textSecondary = Color(0xFF757575);   // Medium Grey
  static const Color textHint = Color(0xFFBDBDBD);        // Light Grey

  // Status colors
  static const Color success = Color(0xFF4CAF50);         // Green
  static const Color error = Color(0xFFF44336);           // Red
  static const Color warning = Color(0xFFFF9800);         // Orange
  static const Color info = Color(0xFF2196F3);            // Blue

  // Create the theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: surfaceColor,
        error: error,
      ),
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
} 