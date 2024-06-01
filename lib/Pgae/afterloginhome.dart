import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firelogin/sub/Charge.dart';

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? userImageUrl;
  double? userMoney;
  String? userName;

  // 추가: 로딩 상태를 나타내는 변수
  bool _isLoading = false;

  Future<void> _logout() async {
    try {
      // 로딩 상태 표시
      setState(() => _isLoading = true);

      // Firestore에 돈 저장
      await _saveMoney();

      // 사용자 로그아웃
      await _auth.signOut();

      // 로딩 상태 해제
      setState(() => _isLoading = false);

      // 로그인 화면으로 이동
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // 에러 처리
      setState(() => _isLoading = false);
      print("An error occurred during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 실패: $e')),
      );
    }
  }

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
      DocumentSnapshot userInfo = await _firestore.collection('user_info').doc(widget.userId).get();
      setState(() {
        userImageUrl = userInfo['imageUrl'];
        userMoney = userInfo['money']?.toint();
        userName = userInfo['name'];
      });
    } catch (e) {
      print('Failed to get user info: $e');
    }
  }

  void _chargeMoney(int amount) {
    setState(() {
      userMoney = (userMoney ?? 0) + amount;
    });
  }

  Future<void> _saveMoney() async {
    if (userMoney != null) {
      await _firestore.collection('user_info').doc(widget.userId).update({
        'money': userMoney,
      });
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
              accountEmail: Text(widget.userId),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userImageUrl ?? 'https://example.com/default_image.png'),
              ),
            ),
            ListTile(
              title: Text('Money: ${userMoney?.toInt() ?? '0'}원'),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChargePage(userId: widget.userId, onCharge: _chargeMoney)),
                  );
                  _getUserInfo();
                },
                child: Text('충전'),
              ),
            ),
            ListTile(
              /* title: ElevatedButton(
                onPressed: () async {
                  await _saveMoney();
                  await _auth.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                ),*/
                title: ElevatedButton(
                  onPressed: _isLoading ? null : _logout, // 로딩 중에는 버튼 비활성화
                  child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        /* 나중에 상품 위젯을 만들 곳


        * */
        child: Text('Home Page'),
      ),
    );
  }
}
