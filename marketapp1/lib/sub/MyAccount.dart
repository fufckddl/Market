import 'package:flutter/material.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Place',
      home: MyAccount(),
    );
  }
}

class MyAccount extends StatefulWidget{
  @override
  State<MyAccount> createState() => _MyAccount();
}

class _MyAccount extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보(My Account)'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(radius: 50.0, backgroundImage: AssetImage('../img/human.jpg'),),
              SizedBox(height: 20), // CircleAvatar와 Text 사이의 공간
              Text('User Name'),
              SizedBox(height: 50), // 그룹 간의 수직 간격
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /**
                   * Button으로 변경해야함.
                   */
                  Text('구매중'),
                  SizedBox(width: 30),
                  Text('배송 완료'),
                  SizedBox(width: 30),
                  Text('장바구니')
                ],
              ),
              // 추가적인 그룹들...
            ],
          ),
        ),
      ),
    );
  }
}
