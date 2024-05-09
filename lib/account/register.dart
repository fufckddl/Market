import 'package:flutter/material.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        title: Text('회원 가입'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 300,
                  height: 30,
                  child: Row(
                    children: <Widget>[
                      Text('이름', style: TextStyle(fontSize: 15, color: Colors.blue)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 15),
                          controller: name,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // 밑줄 스타일 지정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 300,
                  height: 30,
                  child: Row(
                    children: <Widget>[
                      Text('아이디', style: TextStyle(fontSize: 15, color: Colors.blue)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 15),
                          controller: id,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // 밑줄 스타일 지정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 300,
                  height: 30,
                  child: Row(
                    children: <Widget>[
                      Text('비밀번호', style: TextStyle(fontSize: 15, color: Colors.blue)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 15),
                          controller: pwd,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // 밑줄 스타일 지정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 300,
                  height: 30,
                  child: Row(
                    children: <Widget>[
                      Text('나이', style: TextStyle(fontSize: 15, color: Colors.blue)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 15),
                          controller: age,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // 밑줄 스타일 지정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: (){},
                  child: Text('가입하기'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
