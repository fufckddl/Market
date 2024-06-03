import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemListPage extends StatelessWidget {
  final String userId;

  ItemListPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('item_list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
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
                title: Text('상품 명: ' + data['item_name']),
                subtitle: Text('상품 설명: ' + data['item_info']),
                trailing: Text('가격: ${data['item_price']}원'),
                onTap: () {
                  // 여기에서 item.id를 _showPurchaseDialog 함수에 전달합니다.
                  _showPurchaseDialog(context, data['item_name'], data['item_price'], data['item_seller'], item.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String itemName, int itemPrice, String sellerId, String itemId) async {
    if (userId == sellerId) {
      _showErrorDialog(context, '자신의 물품은 구매/판매 할 수 없습니다.');
      return;
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

                    // 여기에서 특정 아이템의 ID를 사용하여 Firestore에서 해당 아이템을 삭제합니다.
                    await transaction.delete(FirebaseFirestore.instance.collection('item_list').doc(itemId));
                  });
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  _showSuccessDialog(context, '구매가 완료되었습니다.');

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