import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Upload',
      home: ItemUpload(),
    );
  }
}

class ItemUpload extends StatefulWidget{
  @override
  State<ItemUpload> createState() {
    return _ItemUpload();
  }
}

class _ItemUpload extends State<ItemUpload>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Upload'),
      ),
      body: Center(
        child: Column(
        ),
      ),
    );
  }
}
