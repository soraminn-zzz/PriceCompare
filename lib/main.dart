import 'package:flutter/material.dart';
import 'package:price_compare/compare_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final themeIndex = prefs.getInt('themeMode') ?? 0;
      _themeMode = ThemeMode.values[themeIndex];

      _backgroundImagePath = prefs.getString('backgroundImagePath');

      _cardOpacity = prefs.getDouble('cardOpacity') ?? 1.0;
    });
  }

  void _toggleTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  void _setBackground(String? path) async {
    setState(() {
      _backgroundImagePath = path;
    });
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString('backgroundImagePath', path);
    } else {
      await prefs.remove('backgroundImagePath');
    }
  }

  void _setCardOpacity(double value) async {
    setState(() {
      _cardOpacity = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cardOpacity', value);
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