import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediscan/largebutton.dart';
import 'package:mediscan/selectresult.dart';
import 'package:mediscan/theme/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UploadShapeData {
  String selectedShape;
  String frontMark;
  String backMark;
  File? frontImage;
  File? backImage;

  UploadShapeData({
    required this.selectedShape,
    required this.frontMark,
    required this.backMark,
    this.frontImage,
    this.backImage,
  });
}

class UploadPage extends StatefulWidget {
  final UploadShapeData shapeData;

  const UploadPage({super.key, required this.shapeData});

  @override
  UploadPageState createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  bool isWarning = false; //경고 색상 표시 여부

  void setWarning(bool warning) {
    setState(() {
      isWarning = warning;
    });
  }

  void setFrontImage(File image) {
    setState(() {
      widget.shapeData.frontImage = image;
    });
  }

  void setBackImage(File image) {
    setState(() {
      widget.shapeData.backImage = image;
    });
  }

  Future<void> sendPostRequest() async {
    final String? baseUrl = dotenv.env['PROJECT_URL'];
    print("Base URL: $baseUrl");
    if (baseUrl == null) {
      print("PROJECT_URL is not set in .env file");
      return;
    }

    // Ensure the base URL ends with a '/'
    final Uri url =
        Uri.parse(baseUrl.endsWith('/pill') ? baseUrl : '$baseUrl/pill');
    print("$url");

    // 원래 파일 경로를 사용하여 파일 업로드 수행
    final frontImagePath = widget.shapeData.frontImage?.path ?? '';
    final backImagePath = widget.shapeData.backImage?.path ?? '';

    print(
        "${widget.shapeData.selectedShape}, ${widget.shapeData.frontMark}, ${widget.shapeData.backMark}");
    print("Front Image: $frontImagePath");
    print("Back Image: $backImagePath");

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'frontImage',
        frontImagePath,
        contentType: MediaType('image', 'jpg'),
      ))
      ..files.add(await http.MultipartFile.fromPath(
        'backImage',
        backImagePath,
        contentType: MediaType('image', 'jpg'),
      ))
      ..fields['pillShape'] = widget.shapeData.selectedShape
      ..fields['frontMarking'] = widget.shapeData.frontMark
      ..fields['backMarking'] = widget.shapeData.backMark;

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        print("Data sent successfully: $jsonResponse");
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SelectPage(
              responseData: jsonResponse['data'],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
            opaque: false,
            barrierColor: Colors.transparent,
          ),
        );
      } else {
        print("Failed to send data: ${response.statusCode}");
        final responseData = await response.stream.bytesToString();
        print("Response body: $responseData");
      }
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  String removeBeforeImagePicker(String path) {
    final index = path.indexOf('image_picker');
    return index != -1 ? path.substring(index) : path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/back.png',
                        width: 9,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      highlightColor: Colors.transparent,
                    ),
                  ),
                  PhotoUploadComponent(
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                    frontImage: widget.shapeData.frontImage,
                    backImage: widget.shapeData.backImage,
                    setFrontImage: setFrontImage,
                    setBackImage: setBackImage,
                  ),
                ],
              ),
            ),
          ),
          // Text(
          //   'Front Image: ${removeBeforeImagePicker(widget.shapeData.frontImage?.path ?? '')}, '
          //   'Back Image: ${removeBeforeImagePicker(widget.shapeData.backImage?.path ?? '')}',
          // ),
          // Text(
          //   '${widget.shapeData.selectedShape}, ${widget.shapeData.frontMark}, ${widget.shapeData.backMark}',
          // ),
          Builder(
            builder: (BuildContext context) {
              return LargeButton(
                buttonText: "결과 확인하기",
                selectedShape: widget.shapeData.selectedShape,
                frontMark: widget.shapeData.frontMark,
                backMark: widget.shapeData.backMark,
                frontImage: widget.shapeData.frontImage,
                backImage: widget.shapeData.backImage,
                onPressed: () {
                  if (widget.shapeData.frontImage == null ||
                      widget.shapeData.backImage == null) {
                    setWarning(true);
                  } else {
                    sendPostRequest();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class PhotoUploadComponent extends StatefulWidget {
  final bool isWarning;
  final Function(bool) onWarningChanged;
  final File? frontImage;
  final File? backImage;
  final Function(File) setFrontImage;
  final Function(File) setBackImage;

  const PhotoUploadComponent(
      {super.key,
      required this.isWarning,
      required this.onWarningChanged,
      required this.setFrontImage,
      required this.setBackImage,
      this.frontImage,
      this.backImage});

  @override
  PhotoUploadState createState() => PhotoUploadState();
}

class PhotoUploadState extends State<PhotoUploadComponent> {
  Widget buildImage(
    String title,
    File? image,
    bool isFront,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NotoSans700',
            fontSize: 20,
            color: mainColor,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 140,
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image != null
                ? GestureDetector(
                    onTap: () => {
                      onPhoto(ImageSource.camera, isFront),
                      if (widget.isWarning == true)
                        {
                          widget.onWarningChanged(false),
                        }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: mainColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => {
                      onPhoto(ImageSource.camera, isFront),
                      if (widget.isWarning == true)
                        {
                          widget.onWarningChanged(false),
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteColor,
                      foregroundColor: whiteColor,
                      surfaceTintColor: whiteColor,
                      side: const BorderSide(color: mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/plus.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 16, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '(필수) 정확성을 위해 알약의 앞, 뒤를 모두 업로드해주세요.',
              style: TextStyle(
                color: widget.isWarning ? redColor : deleteColor,
                fontFamily: 'NotoSans500',
                fontSize: 14,
              ),
            ),
          ),
        ),
        Divider(
          color: widget.isWarning ? redColor : deleteColor,
          thickness: 1,
          height: 0,
          indent: 0,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImage("앞", widget.frontImage, true),
            const SizedBox(width: 32),
            buildImage("뒤", widget.backImage, false),
          ],
        ),
      ],
    );
  }

  void onPhoto(ImageSource source, bool isFront) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          widget.setFrontImage(File(pickedFile.path));
        } else {
          widget.setBackImage(File(pickedFile.path));
        }
      });
    }
  }
}
