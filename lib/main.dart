import 'package:flutter/material.dart';
import 'package:marketapp/sub/ItemList.dart';
import 'package:marketapp/sub/MyAccount.dart';
import 'package:marketapp/login_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Market Place',
      home: const MyHomePage(), //home 속성 추가
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

 // @override
 // Widget build(BuildContext context) {
   // return const MaterialApp(
     // debugShowCheckedModeBanner: false,//디버그 모드에서 디버그 배너가 표시 않됨. 조금만 더 빠르게 하려고
      //home: pre_page(),
    //);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Place'),
        leading:
            // Builder 위젯 추가
            Builder(builder: (context)=> IconButton(
              onPressed: () {Scaffold.of(context).openDrawer();
                },
              icon: const Icon(Icons.menu),
            )),
        backgroundColor: Colors.white,
        elevation: 4, //그림자(회색?)
      ),
      /**
       * leading 속성은 AppBar 위젯의 왼쪽에 위치한 위젯을 지정하는 속성
       * Builder위젯을 사용한 이유는 AppBar 내부에서 Scaffold.of(context)
       * 호출할 때 발생하는 오류를 해결하기 위함임
       * AppBar는 StatelessWidget이므로 자체적으로 BuildContext 생성안함
       * 그래서 AppBar내에서 Scaffold.of(context)를 호출하면 오류발생함
       *
       * Builder 위젯을 사용하면 새로운 BuildContext 생성가능
       * 이는 AppBar내에서 새로운 context를 만들어서 Scaffold를 찾을 수 있는
       * 해결책을 제공함.
       *
       * 따라서 leading 속성에 Builder를 사용하여 IconButton을 감사는 것은
       * AppBar 내부에서 Scaffold를 찾기 위함임
       *
       * 아래와 같이 Builder를 사용하므로써 IconButton 이나 다른 위젯이
       * AppBar의 하위 위젯인것처럼 동작시킬 수 있음.
       */



    drawer:
    Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            /**
             * DrawerHeader의 높이를 조절하려면
             * ListTile로 변경해서 직접 조절해야함.
             * 이상태에서 조절하는 방법은 없음.
             */
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('로그인(Login_Page)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const LoginPage())

                );
              }
            ),
            ListTile(
              title: const Text('내 정보(My Account)'),
              onTap: () {
                /**
                 * Navigator.push()는 현재 화면에서 새로운 화면으로 이동
                 * MaterialPageRoute을 사용하여 이동할 화면을 지정
                 * 이동할 화면의 StatefulWidget을 생성하여 builder함수에
                 * 전달하여 화면을 이동시킴
                 */
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccount()),
                );
              },
            ),
            ListTile(
              title: const Text('상품 구매(Item List)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemList()),
                );
              },
            ),
            ListTile(
              title: const Text('메뉴 3'),
              onTap: () {
                //메뉴 1번이 선택되었을 때 수행할 동작
              },
            ),
          ],
        )
    ),
    );

  }
}
