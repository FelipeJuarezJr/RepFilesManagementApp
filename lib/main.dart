import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';
import 'package:repfiles/routes.dart';
import 'package:repfiles/screens/home_screen.dart';

void main() {
  print('Starting RepFiles App');
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const RepFilesApp(),
    ),
  );
}

class RepFilesApp extends StatelessWidget {
  const RepFilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepFiles',
      theme: ThemeData(
        primaryColor: const Color(0xFF348944), // Green color from original app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF348944),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
} 