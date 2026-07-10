import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fitness_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FitnessProvider()..loadWorkouts(),
      child: MaterialApp(
        title: 'Fitness Tracker',
        theme: ThemeData(
          primaryColor: const Color(0xFF00C853),
          scaffoldBackgroundColor: const Color(0xFFF8F9FE),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00C853),
            secondary: Color(0xFFFF6D00),
            tertiary: Color(0xFF2196F3),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF00C853),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}