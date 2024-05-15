import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/account/register.dart';
import 'package:marketplace/sub/ItemList.dart';
import 'package:marketplace/sub/MyAccount.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Market Place Example',
      home: const MyHomePage(),
      );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController id = TextEditingController(), pwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Place'),
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
        leading: Builder(
          builder: (BuildContext context) { // Builder 위젯 추가
            return IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 4,//그림자(회색?)
      ),
      drawer: Drawer(
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
                title: const Text('내 정보(My Account)'),
                onTap:(){
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
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemList()),
                  );
                },
              ),
              ListTile(
                title: const Text('메뉴 3'),
                onTap:(){
                  //메뉴 1번이 선택되었을 때 수행할 동작
                },
              ),
            ],
          )
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Enter Email", style: TextStyle(fontSize: 15, color: Colors.blue),),
              Container(
                width: 300, // 텍스트 필드의 최대 너비를 설정
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: id,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              const Text("Enter Password", style: TextStyle(fontSize: 15, color: Colors.blue),),
              Container(
                width: 300, // 텍스트 필드의 최대 너비를 설정
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: pwd,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25), // TextField와 ElevatedButton 사이의 간격을 조절
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: (){
                      /**
                       * 로그인시 json파일 비교해서 로그인 확인.
                       */
                    },
                    child: const Text("로그인"),
                  ),
                  SizedBox(width: 15), // ElevatedButton 간의 간격을 조절
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text("회원가입"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
