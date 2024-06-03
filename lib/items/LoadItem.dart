import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemListPage extends StatelessWidget {
  final String userId; // 사용자의 ID를 저장하는 변수

  ItemListPage({required this.userId}); // 생성자를 통해 사용자의 ID를 전달받음

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
                  _showPurchaseDialog(context, data['item_name'], data['item_price'], data['item_seller']);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String itemName, int itemPrice, String sellerId) async {
    if (userId == sellerId) {
      _showErrorDialog(context, '자신의 물품은 구매/판매 할 수 없습니다.');
      return; // 구매자와 판매자가 같은 경우, 다이얼로그를 띄우지 않고 리턴
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('구입하시겠습니까?'),
          content: Text('상품: $itemName\n가격: $itemPrice원'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                final int totalPrice = itemPrice;

                try {
                  print('userId: $userId');
                  print('sellerId: $sellerId');

                  // 사용자 문서를 쿼리로 가져오기
                  final userQuerySnapshot = await FirebaseFirestore.instance
                      .collection('user_info')
                      .where('id', isEqualTo: userId)
                      .get();
                  final sellerQuerySnapshot = await FirebaseFirestore.instance
                      .collection('user_info')
                      .where('id', isEqualTo: sellerId)
                      .get();

                  if (userQuerySnapshot.docs.isEmpty || sellerQuerySnapshot.docs.isEmpty) {
                    print('UserDoc exists: ${userQuerySnapshot.docs.isNotEmpty}');
                    print('SellerDoc exists: ${sellerQuerySnapshot.docs.isNotEmpty}');
                    _showErrorDialog(context, '사용자 정보를 가져올 수 없습니다.');
                    return;
                  }

                  final userDoc = userQuerySnapshot.docs.first;
                  final sellerDoc = sellerQuerySnapshot.docs.first;

                  final userMoney = userDoc.data()?['money'];
                  final sellerMoney = sellerDoc.data()?['money'];

                  print('userMoney: $userMoney');
                  print('sellerMoney: $sellerMoney');

                  if (userMoney == null || sellerMoney == null) {
                    _showErrorDialog(context, '금액 정보를 가져올 수 없습니다.');
                    return;
                  }

                  if (userMoney < totalPrice) {
                    _showErrorDialog(context, '돈이 부족합니다.');
                    return;
                  }

                  await FirebaseFirestore.instance.runTransaction((transaction) async {
                    transaction.update(userDoc.reference, {'money': userMoney - totalPrice});
                    transaction.update(sellerDoc.reference, {'money': sellerMoney + totalPrice});
                  });

                  _showSuccessDialog(context, '구매가 완료되었습니다.');
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                } catch (e) {
                  print('Error: $e');
                  _showErrorDialog(context, '오류가 발생했습니다: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('에러'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('성공'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ItemListPage(userId: 'dlckdfuf'),
  ));
}
