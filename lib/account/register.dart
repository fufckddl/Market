import 'package:flutter/material.dart';
//import 'package:marketplace/account/user.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Register',
      home: Register(),
    );
  }
}

class Register extends StatefulWidget{
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController id = TextEditingController(),
  pwd = TextEditingController(),
  name = TextEditingController(),
  age = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 각 Row를 화면 중앙에 위치시킴
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('이름'),
                ),
                const SizedBox(width: 10), // 텍스트와 텍스트 필드 사이의 간격 조정
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('아이디'),
                ),
                const SizedBox(width: 10), // 텍스트와 텍스트 필드 사이의 간격 조정
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: id,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('비밀번호'),
                ),
                const SizedBox(width: 10), // 텍스트와 텍스트 필드 사이의 간격 조정
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: pwd,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('나이'),
                ),
                const SizedBox(width: 10), // 텍스트와 텍스트 필드 사이의 간격 조정
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: age,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    // 사용자 정보 생성
                    /*final user = User(
                      id: 'user123',
                      password: 'password123',
                      age: '25', // 나이를 문자열로 저장하도록 수정했습니다.
                      name: 'John Doe',
                    );*/

                    // 사용자 정보 저장

                    //user.saveUserInfo(); // saveUserInfo 함수 호출 시 인스턴스를 통해 호출합니다.
                  },
                  child: const Text("가입하기"),
                ),

              ],
            ),
          ],
        ),
      ),



    );
  }
}
