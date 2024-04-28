import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image1;
  File? _image2;

  Future getImage(bool isImage1) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        isImage1 ? _image1 = File(pickedFile.path) : _image2 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendPostRequest() async {
    // 서버에 보낼 URL 저기에 넣으면 됨
    final Uri url = Uri.parse('https://example.com/api');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: '{"key": "value"}', // 보낼 데이터 값!!
    );

    if (response.statusCode == 200) {
      print("Data sent successfully");
    } else {
      print("Failed to send data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MediScan'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () => getImage(true),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: _image1 != null ? DecorationImage(image: FileImage(_image1!), fit: BoxFit.cover) : null,
                  ),
                  child: _image1 == null ? Icon(Icons.add_a_photo) : null,
                ),
              ),
              GestureDetector(
                onTap: () => getImage(false),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: _image2 != null ? DecorationImage(image: FileImage(_image2!), fit: BoxFit.cover) : null,
                  ),
                  child: _image2 == null ? Icon(Icons.add_a_photo) : null,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: sendPostRequest,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('결과 확인하기'),
          ),
        ),
      ),
    );
  }
}
