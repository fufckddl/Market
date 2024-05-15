import 'package:flutter/material.dart';
import 'package:marketapp/main.dart'; // 추가

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '이메일',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '이메일 입력',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '비밀번호 입력',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 로그인 처리 (예: API 호출)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  }
                },
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}