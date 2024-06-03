import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace/items/LoadItem.dart';
import 'package:marketplace/sub/Charge.dart';
import 'package:marketplace/items/UploadItem.dart';
import 'package:marketplace/sub/MyAccount.dart';
import 'package:marketplace/items/LoadItem.dart';


class HomePage extends StatefulWidget {
  final String userUid;

  HomePage({required this.userUid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? userId;
  String? userImageUrl;
  int userMoney = 0;
  String? userName;
  String? documentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getUserInfo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getUserInfo();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _getUserInfo() async {
    try {
      // Firestore 컬렉션에서 데이터 쿼리
      QuerySnapshot querySnapshot = await _firestore.collection('user_info')
          .where('id', isEqualTo: widget.userUid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userInfo = querySnapshot.docs.first;
        setState(() {
          documentId = userInfo.id; // Firestore 문서의 ID 저장
          //userImageUrl = userInfo['imageUrl'];
          userMoney = userInfo['money'] ?? 0;
          userName = userInfo['name'];
          userId = userInfo['id'];
        });
        print('User info retrieved: $userInfo');
      } else {
        print('User info not found in Firestore for user ID: ${widget.userUid}');
      }
    } catch (e) {
      print('Failed to get user info: $e');
    }
  }


  void _chargeMoney(int amount) {
    setState(() {
      userMoney += amount;
    });
    _saveMoney(); // 충전 시 바로 저장
  }

  Future<void> _saveMoney() async {
    try {
      if (documentId != null) {
        await _firestore.collection('user_info').doc(documentId).update({
          'money': userMoney,
        });
        print("Money updated successfully");
      } else {
        print("No document ID found to update money");
      }
    } catch (e) {
      print("Failed to update money: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName ?? 'Guest'),
              accountEmail: Text(widget.userUid),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userImageUrl ?? 'https://i.ibb.co/LRmjqnz/human.jpg'),
              ),
            ),
            ListTile(
              title: Text('Money: ${userMoney.toString()}원'),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChargePage(userId: widget.userUid, onCharge: _chargeMoney)),
                  );
                  _getUserInfo();
                },
                child: Text('충전'),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyItemsPage(userUid: userId,))
                  );
                  _getUserInfo();
                },
                child: Text('내 정보'),
              ),
            ),

            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  // userId가 null이 아닌지 확인
                  if (userId != null) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ImageUploadPage(itemSeller: userId!)),
                    );
                    _getUserInfo();
                  } else {
                    print('User ID is null, cannot navigate to ImageUploadPage');
                  }
                },
                child: Text('상품판매'),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ItemListPage(userId: userId!,)),
                  );
                  _getUserInfo();
                },
                child: Text('상품목록'),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  await _saveMoney();
                  await _auth.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      body: ItemListPage(userId: '',));;

  }
}
