import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firelogin/sub/Charge.dart';

class HomePage extends StatefulWidget {
  final String userUid;

  HomePage({required this.userUid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
      QuerySnapshot querySnapshot = await _firestore.collection('user_info')
          .where('id', isEqualTo: widget.userUid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userInfo = querySnapshot.docs.first;
        setState(() {
          documentId = userInfo.id; // Firestore 문서의 ID 저장
          userImageUrl = userInfo['imageUrl'];
          userMoney = userInfo['money'] ?? 0;
          userName = userInfo['name'];
        });
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
                backgroundImage: NetworkImage(userImageUrl ?? 'https://example.com/default_image.png'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Page'),
            SizedBox(height: 20),
            Text('Money: ${userMoney.toString()}원', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
