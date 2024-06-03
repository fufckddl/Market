import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/account/login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();

  Future<void> _signUp() async {
    final String id = _idController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final int? money = int.tryParse(_moneyController.text);

    if (money == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Money must be a valid number.'))
      );
      return;
    }

    try {
      // Firestore에서 동일한 ID가 있는지 확인
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_info')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 동일한 ID가 이미 존재할 경우 예외 처리
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ID already exists.'))
        );
        return;
      }

      // 동일한 ID가 없을 경우 회원가입 진행
      await FirebaseFirestore.instance.collection('user_info').add({
        'id': id,
        'password': password,
        'name': name,
        'email': email,
        'money': money,
      });

      // 회원가입 후 로그인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _moneyController,
              decoration: InputDecoration(labelText: 'Money'),
              keyboardType: TextInputType.number, // 숫자 입력만 가능하게 설정
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
