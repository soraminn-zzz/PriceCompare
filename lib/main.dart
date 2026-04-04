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
          'unitprice': unitPriceA,
        },
        {
          'name': '$name (B)',
          'price': priceB,
          'quantity': quantityB,
          'unitprice': unitPriceB,
        }
      ]);
    });
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

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceControllerA,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '価格A',
                      border: OutlineInputBorder(),
                  ),
                ),
              ),

            const SizedBox(width: 16),

            Expanded(
              child: TextField(
                controller: _quantityControllerA,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '単位A',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: TextField(
                controller: _priceControllerB,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '価格B',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
              
            Expanded(
              child: TextField(
                controller: _quantityControllerB,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '単位B',
                  border: OutlineInputBorder(),
                ),
              ),
            ),


                
            ],
          ),

              

            ElevatedButton(
              onPressed: () {
                _addProduct();
              },
              child: const Text('比較'),
            ),

            Expanded(
              child: _compareList.isEmpty
                  ?
                    const Center(
                      child: Text(
                        '商品を追加してください',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  :
                    Builder(
                      builder: (context) {
                        final cheapestIndex = _cheapestIndex();

                        return ListView.builder(
                          itemCount: _compareList.length,
                          itemBuilder: (context, index) {
                            final item = _compareList[index];

                            return ListTile(
                              leading: index == cheapestIndex
                                  ? const Icon(Icons.star, color: Colors.amber,)
                                  : const Icon(Icons.star, color: Colors.grey),

                              title: Text(item['name'] ?? '名称未設定'),
                              subtitle: Text('価格: ${item['price']}円 / 単位: ${item['quantity']}'),
                              trailing: Text('単価: ${item['unitprice'].toStringAsFixed(1)}'),
                                  );
                          },
                        );
                      },
                    )
            )
          ],
        ),
      ),
    );
  }
}