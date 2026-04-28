import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentMode;
  final String? backgroundImagePath;
  final Function(String?) onBackgroundChanged;
  final Function(double) onCardOpacityChanged;
  final double cardOpacity;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentMode,
    required this.backgroundImagePath,
    required this.onBackgroundChanged,
    required this.onCardOpacityChanged,
    required this.cardOpacity
  });

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  late double _localOpacity;

  @override
  void initState() {
    super.initState();
    _localOpacity = widget.cardOpacity;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickImage != null) {
      widget.onBackgroundChanged(pickImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('設定')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('ダークモード'),
            value: widget.currentMode == ThemeMode.dark,
            onChanged: (bool value) {
              widget.onThemeChanged(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.image),
                label: Text('背景画像を選ぶ'),
                onPressed: _pickImage,
              ),
            ),
          ),

          if (widget.backgroundImagePath != null) ...[
            Text('透過度: ${(_localOpacity * 100).toInt()}%'),
            Slider(
                value: _localOpacity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _localOpacity = value;
                  });;
                  widget.onCardOpacityChanged(value);
                }
            ),
          ],
        ],
      )
    );
  }
}