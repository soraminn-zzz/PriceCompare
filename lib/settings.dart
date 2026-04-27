import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentMode;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('設定')),
      body: SwitchListTile(
        title: Text('ダークモード'),
        value: widget.currentMode == ThemeMode.dark,
      onChanged: (bool value) {
          widget.onThemeChanged(
            value ? ThemeMode.dark : ThemeMode.light,
          );
      },
      ),
    );
  }
}