import 'package:flutter/material.dart';

class ChargePage extends StatelessWidget {
  final String userId;
  final Function(int) onCharge;

  ChargePage({required this.userId, required this.onCharge});

  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('충전')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: '충전 금액'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                int amount = int.tryParse(_amountController.text) ?? 0;
                onCharge(amount);
                Navigator.pop(context); // 충전 후 페이지 닫기
              },
              child: Text('충전'),
            ),
          ],
        ),
      ),
    );
  }
}
