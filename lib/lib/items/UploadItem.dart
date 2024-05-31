import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageUploadPage(),
    );
  }
}

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  Uint8List? _imageData;
  String? _uploadedImageUrl;
  String? _fileName;

  final TextEditingController _nameController = TextEditingController();
  //final TextEditingController _countController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

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

  Future<void> _uploadImage() async {
    if (_imageData == null) {
      print('No image data to upload');
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

        await FirebaseFirestore.instance.collection('item_list').add({
          'item_img_url': _uploadedImageUrl,
          'item_name': _nameController.text,
          'item_price': _priceController.text,
          'item_info': _infoController.text,
        });

        print('Item added to Firestore');
      } else {
        print('Image upload failed');
      }
    } catch (e) {
      print('Image upload failed: $e');
    }
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
