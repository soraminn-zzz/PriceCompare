import 'package:flutter/material.dart';
import 'package:price_compare/compare_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  String? _backgroundImagePath;
  double _cardOpacity = 1.0;

  void _toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _setBackground(String? path) {
    setState(() {
      _backgroundImagePath = path;
    });
  }

  void _setCardOpacity(double value) {
    setState(() {
      _cardOpacity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price-Compare-App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: CompareScreen(
          onThemeChanged: _toggleTheme, currentMode: _themeMode,
          onBackgroundChanged: _setBackground, backgroundImagePath: _backgroundImagePath,
          onCardOpacityChanged: _setCardOpacity, cardOpacity: _cardOpacity,
      ),
    );
  }
}