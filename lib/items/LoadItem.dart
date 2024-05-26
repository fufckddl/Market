import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ItemListPage(),
    );
  }
}

class ItemListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('item_list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(data['item_img_url']),
                title: Text(data['item_name']),
                subtitle: Text(data['item_info']),
                trailing: Text('${data['item_price']}원'),
                onTap: () {
                  _showPurchaseDialog(context, data['item_name']);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String itemName) {
    final TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('구입할 개수를 입력하세요'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "개수"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                final int quantity = int.tryParse(_quantityController.text) ?? 0;
                if (quantity > 0) {
                  // Perform any action you want with the quantity
                  print('Item: $itemName, Quantity: $quantity');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
