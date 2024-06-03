import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:marketplace/sub/MyAccount.dart';
import 'account/login.dart';
import 'account/signup.dart';

import 'items/UploadItem.dart';
import 'items/LoadItem.dart';


void init() async{
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyASp_WdOVL_Ib46yscky-BCSVj2Jvq52Og",
        authDomain: "market-8ba06.firebaseapp.com",
        projectId: "market-8ba06",
        storageBucket: "market-8ba06.appspot.com",
        messagingSenderId: "210819083785",
        appId: "1:210819083785:web:e07bd51dd00de9f92952d8",
        measurementId: "G-1072P2XBQS",
        databaseURL: 'https://market-8ba06.firebaseio.com',
      ),
    );
    runApp(const MyApp());
  } catch (error) {
    // Handle initialization error
    print("Firebase initialization failed: $error");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Market Place Example',
      home: MyHomePage(),
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
  bool _isLoggedIn = false;

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
              /*ListTile(
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
                    MaterialPageRoute(builder: (context) => MyItemsPage()),
                  );
                },
              ),*/
              /*ListTile(
                title: const Text('상품 목록(Item List)'),
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemListPage()),
                  );
                },
              ),*/
              const SizedBox(height: 25), // TextField와 ElevatedButton 사이의 간격을 조절
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  LoginScreen()),
                      );
                    },
                    child: const Text("로그인"),
                  ),
                  const SizedBox(width: 15), // ElevatedButton 간의 간격을 조절
                  ElevatedButton(
                    onPressed: () {
                      setState((){
                        _isLoggedIn = true;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  SignUpPage()),
                      );
                    },
                    child: const Text("회원가입"),
                  ),
                ],
              ),

            ]
        ),
      ),
      body: ItemtoList(),
    );
  }
}class ItemtoList extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'name': 'Item 1',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 2',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },{
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },{
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },{
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },{
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },{
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Item 3',
      'image': 'https://via.placeholder.com/150',
    },






  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Card(
            child: Row(
              children: [
                Image.network(
                  item['image']!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Text(item['name']!),
              ],
            ),
          ),
        );
      },
    );
  }
}