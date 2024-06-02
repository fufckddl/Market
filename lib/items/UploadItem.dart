import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../page/afterloginhome.dart';

class ImageUploadPage extends StatefulWidget {
  final String itemSeller;

  ImageUploadPage({required this.itemSeller});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  Uint8List? _imageData;
  String? _uploadedImageUrl;
  String? _fileName;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageData = result.files.single.bytes;
        _fileName = result.files.single.name;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<int> _getNextItemNumber() async {
    final counterDocRef = FirebaseFirestore.instance.collection('counters').doc('item_counter');
    final counterDoc = await counterDocRef.get();

    if (counterDoc.exists) {
      final currentCount = counterDoc['count'] as int;
      await counterDocRef.update({'count': currentCount + 1});
      return currentCount + 1;
    } else {
      await counterDocRef.set({'count': 1});
      return 1;
    }
  }

  Future<void> _uploadImage() async {
    if (_imageData == null || widget.itemSeller == null) {
      print('No image data or item seller info to upload');
      return;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=1e1b35aea05fbc7010d69f0c43b63337'),
      );
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _imageData!,
        filename: _fileName,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final jsonResponse = json.decode(responseBody.body);
        final downloadUrl = jsonResponse['data']['url'];

        setState(() {
          _uploadedImageUrl = downloadUrl;
        });

        print('Image uploaded: $_uploadedImageUrl');

        final itemNumber = await _getNextItemNumber();

        await FirebaseFirestore.instance.collection('item_list').add({
          'item_number': itemNumber,
          'item_seller': widget.itemSeller,
          'item_img_url': _uploadedImageUrl,
          'item_name': _nameController.text,
          'item_price': _priceController.text,
          'item_info': _infoController.text,
        });

        print('Item added to Firestore');

        // 상품 업로드에 성공하면 HomePage로 이동하고 알림 창 표시
        _showSuccessDialog();
      } else {
        print('Image upload failed');
      }
    } catch (e) {
      print('Image upload failed: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('업로드 성공'),
          content: Text('상품 업로드에 성공하였습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // HomePage로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(userUid: widget.itemSeller!)),
                );
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload to ImageBB and Firestore'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imageData == null
                  ? Text('No image selected.')
                  : Image.memory(_imageData!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image and Add Item'),
              ),
              SizedBox(height: 20),
              _uploadedImageUrl == null
                  ? Container()
                  : SelectableText('Uploaded Image URL: $_uploadedImageUrl'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Item Price'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _infoController,
                  decoration: InputDecoration(labelText: 'Item Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
