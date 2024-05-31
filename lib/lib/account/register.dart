import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firelogin/main.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = null; // Reset error message
    });


    // 입력값 검증: 비밀번호가 숫자만 포함하고 최소 4자리 이상이어야 한다.
    if (!RegExp(r'^\d+$').hasMatch(_passwordController.text)) {
      setState(() {
        _errorMessage = '1. Password must be an integer value.';
      });
      return;
    }

    if (_passwordController.text.length < 4) {
      setState(() {
        _errorMessage = '1-1 Password must be at least 4 digits long.';
      });
      return;
    }

    if (!_emailController.text.contains('@')) {
      setState(() {
        _errorMessage = '2. Invalid email format';
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Firebase Realtime Database에 추가 정보 저장
      DatabaseReference ref = FirebaseDatabase.instance.ref("user_info/${userCredential.user!.uid}");
      await ref.set({
        'id': _idController.text,
        'password': int.parse(_passwordController.text),
        'name': _nameController.text,
        'money': 0,
        'email': _emailController.text,
      });

      setState(() {
        _errorMessage = null;
      });

      // 회원가입 성공 시 홈 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          setState(() {
            _errorMessage = '3. The email address is already in use by another account.';
          });
          break;
        case 'invalid-email':
          setState(() {
            _errorMessage = '4. The email address is not valid.';
          });
          break;
        case 'operation-not-allowed':
          setState(() {
            _errorMessage = '5. Email/password accounts are not enabled.';
          });
          break;
        case 'weak-password':
          setState(() {
            _errorMessage = '6. The password is not strong enough.';
          });
          break;
       /* default:
          setState(() {
            _errorMessage = '7. An undefined Error happened.';
          });*/
      }
    } catch (e) {
      setState(() {
        _errorMessage = '8. An unexpected error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('회원가입'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/


