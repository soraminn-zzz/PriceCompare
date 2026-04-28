import 'package:flutter/material.dart';
import 'package:price_compare/settings.dart';
import 'dart:io';

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

class CompareScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentMode;
  final Function(String?) onBackgroundChanged;
  final String? backgroundImagePath;
  final Function(double) onCardOpacityChanged;
  final double cardOpacity;

  const CompareScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentMode,
    required this.onBackgroundChanged,
    required this.backgroundImagePath,
    required this.onCardOpacityChanged,
    required this.cardOpacity
  });


  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
      final _compareList = <Map<String, dynamic>>[];
      final _cartList = <Map<String, dynamic>>[];

      final TextEditingController _nameController = TextEditingController();
      final TextEditingController _priceControllerA = TextEditingController();
      final TextEditingController _quantityControllerA = TextEditingController();
      final TextEditingController _priceControllerB = TextEditingController();
      final TextEditingController _quantityControllerB = TextEditingController();
  
  void _addProduct() {
    var name = _nameController.text.trim();

    double? priceA = double.tryParse(_priceControllerA.text.trim());
    double? priceB = double.tryParse(_priceControllerB.text.trim());
    double? quantityA = double.tryParse(_quantityControllerA.text.trim());
    double? quantityB = double.tryParse(_quantityControllerB.text.trim());
    if (name.isEmpty || priceA == null || quantityA == null || priceB == null || quantityB == null) {
      print('エラー： 名前が未入力、または価格・単価が正しく入力されてません');
      return;
    }

    var unitPriceA = priceA / quantityA;
    var unitPriceB = priceB / quantityB;

    setState(() {
      _compareList.clear();
      _compareList.addAll([
        {
          'name': '$name (A)',
          'price': priceA,
          'quantity': quantityA,
          'unitPrice': unitPriceA,
        },
        {
          'name': '$name (B)',
          'price': priceB,
          'quantity': quantityB,
          'unitPrice': unitPriceB,
        }
      ]);

      final cheapestIndex = _cheapestIndex();
      if (cheapestIndex != -1) {
        _cartList.add(_compareList[cheapestIndex]);
      }
    });
    _nameController.clear();
    _priceControllerA.clear();
    _quantityControllerA.clear();
    _priceControllerB.clear();
    _quantityControllerB.clear();
  }

  int _cheapestIndex() {
    if (_compareList.isEmpty) {
      return -1;
    }

    int minIndex = 0;

    double minUnitPrice = double.infinity;

    for (int i = 0; i < _compareList.length; i++) {
      final item = _compareList[i];

      final price = item['price'] as double;
      final quantity = item['quantity'] as double;

      if (quantity > 0) {
        double unitPrice = price / quantity;

        if (unitPrice < minUnitPrice) {
          minUnitPrice = unitPrice;
          minIndex = i;
        }
      }
    }

    return minIndex;
  }


  @override
   void dispose() {
    _nameController.dispose();
    _priceControllerA.dispose();
    _quantityControllerA.dispose();
    _priceControllerB.dispose();
    _quantityControllerB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _cartList.fold(0.0, (sum, item) => sum + item['price']);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('単価比較'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>
              SettingsScreen(
                onThemeChanged: widget.onThemeChanged,
                currentMode: widget.currentMode,
                onBackgroundChanged: widget.onBackgroundChanged,
                backgroundImagePath: widget.backgroundImagePath,
                onCardOpacityChanged: widget.onCardOpacityChanged,
                cardOpacity: widget.cardOpacity,
              )),
              );
              setState(() {});
            },
          ),
        ]
      ),

      body: Stack(
        children: [

          if (widget.backgroundImagePath != null)
            Positioned.fill(
              child: Image.file(
                File(widget.backgroundImagePath!),
                fit: BoxFit.cover,
              ),
            ),
          Opacity(
            opacity: widget.cardOpacity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 全体を左寄せに揃える
                children: [
                  // --- 入力エリア ---
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: '商品名',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _priceControllerA,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: '価格A', border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _quantityControllerA,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: '単位A', border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _priceControllerB,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: '価格B', border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _quantityControllerB,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: '単位B', border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addProduct,
                            child: const Text('比較してカートへ追加'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24), // セクション間の大きな余白

                  // 🌟 比較結果の見出し
                  Text(
                    '比較結果',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, // 必要に応じて太字にするとより見出しらしくなります
                    ),
                  ),
                  const SizedBox(height: 8), // 見出しと中身の小さな余白

                  Expanded(
                    child: _compareList.isEmpty
                        ? const Center(child: Text('比較するデータを入力してください', style: TextStyle(color: Colors.grey)))
                        : Builder(
                      builder: (context) {
                        final cheapestIndex = _cheapestIndex();
                        return ListView.builder(
                          itemCount: _compareList.length,
                          itemBuilder: (context, index) {
                            final item = _compareList[index];
                            return ListTile(
                              leading: index == cheapestIndex
                                  ? const Icon(Icons.star, color: Colors.amber)
                                  : const Icon(Icons.star_border, color: Colors.grey),
                              title: Text(item['name'] ?? '名称未設定'),
                              subtitle: Text('価格: ${item['price']}円 / 単位: ${item['quantity']}'),
                              trailing: Text('単価: ${item['unitPrice'].toStringAsFixed(1)}'),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24), // セクション間の大きな余白

                  // 🌟 ショッピングカートの見出し
                  Text(
                    'ショッピングカート',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: Card(
                      elevation: 2,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _cartList.isEmpty
                            ? const Center(child: Text('カートは空です', style: TextStyle(color: Colors.grey)))
                            : Column(
                          children: [
                            Expanded( // カート内もスクロール可能にするために Expanded を追加
                              child: ListView(
                                children: [
                                  ..._cartList.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return ListTile(
                                      title: Text(item['name']),
                                      subtitle: Text('${item['price']}円'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => setState(() => _cartList.removeAt(index)),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('合計金額:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text(
                                    '${total.toStringAsFixed(0)} 円',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => setState(() => _cartList.clear()),
                              icon: const Icon(Icons.refresh),
                              label: const Text('カートを空にする'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}