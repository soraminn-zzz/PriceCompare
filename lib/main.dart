import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price-Compare-App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CompareScreen(),
    );
  }
}

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});


  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
      final _compareList = <Map<String, dynamic>>[];

      final TextEditingController _nameController = TextEditingController();
      final TextEditingController _priceController = TextEditingController();
      final TextEditingController _quantityController = TextEditingController();
  
  void _addProduct() {
    var name = _nameController.text.trim();

    double? price = double.tryParse(_priceController.text.trim());
    double? quantity = double.tryParse(_quantityController.text.trim());

    if (name.isEmpty || price == null || quantity == null) {
      print('エラー： 名前が未入力、または価格・単価が正しく入力されてません');
      return;
    }

    setState(() {
      var unitPrice = price / quantity;
      _compareList.add({
        'name': name,
        'price': price,
        'quantity': quantity,
        'unitprice': unitPrice,
      });
    });
  }


  @override
   void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('単価比較'),
      ),
      body: Padding(
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

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '価格',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '単位',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                _addProduct();
              },
              child: const Text('比較'),
            )

            
          ],
        ),
      ),
    );
  }
}