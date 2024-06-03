import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MyItemsPage extends StatefulWidget {
  final String? userUid;

  MyItemsPage({this.userUid});

  @override
  _MyItemsPageState createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Items'),
      ),
      body: FutureBuilder(
        future: _fetchUserItems(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items found.'));
          }

          // 사용자가 올린 상품 목록을 보여주는 ListView
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String imageUrl = data['item_img_url']; // 상품 이미지 URL

              return Column(
                children: [
                  ListTile(
                    leading: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image), // 이미지가 없는 경우 기본 아이콘 표시
                    title: Text(data['item_name']),
                    subtitle: Text('Price: ${data['item_price']}원'),
                  ),
                  Divider(), // 리스트 항목 간 구분선 추가
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<QuerySnapshot> _fetchUserItems() {
    return _firestore.collection('item_list')
        .where('item_seller', isEqualTo: widget.userUid)
        .get();
  }
}
