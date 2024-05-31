import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/largebutton.dart';
import 'package:mediscan/theme/colors.dart';
import 'package:mediscan/uploadphoto.dart';

class CapsuleScan extends StatefulWidget {
  const CapsuleScan({super.key});

  @override
  CapsuleScanState createState() => CapsuleScanState();
}

class CapsuleScanState extends State<CapsuleScan> {
  String selectedShape = ''; //선택한 알약 모양
  String frontMark = ''; //작성한 식별표시 앞
  String backMark = ''; //작성한 식별표시 뒤
  bool isWarning = false; //경고 색상 표시 여부
  File? frontImage; //약 이미지 앞
  File? backImage; //약 이미지 뒤

  void setSelectedShape(String shape) {
    setState(() {
      selectedShape = shape;
    });
  }

  void setFrontMark(String mark) {
    setState(() {
      frontMark = mark;
    });
  }

  void setBackMark(String mark) {
    setState(() {
      backMark = mark;
    });
  }

  void setWarning(bool warning) {
    setState(() {
      isWarning = warning;
    });
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
                  ShapeComponent(
                    selectedShape: selectedShape,
                    onShapeSelected: setSelectedShape,
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                  ),
                  MarkComponent(
                    frontMark: frontMark,
                    backMark: backMark,
                    onFrontMarkChanged: setFrontMark,
                    onBackMarkChanged: setBackMark,
                  ),
                ],
              ),
            ),
          ),
          Text('$selectedShape $frontMark $backMark'),
          Builder(
            builder: (BuildContext context) {
              return LargeButton(
                buttonText: "알약 스캔하기",
                selectedShape: selectedShape,
                frontMark: frontMark,
                backMark: backMark,
                frontImage: frontImage,
                backImage: backImage,
                onPressed: () {
                  if (selectedShape == '') {
                    setWarning(true);
                  } else {
                    UploadShapeData data = UploadShapeData(
                      selectedShape: selectedShape,
                      frontMark: frontMark,
                      backMark: backMark,
                      frontImage: frontImage,
                      backImage: backImage,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadPage(shapeData: data),
                      ),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}

//알약 모양 선택
class ShapeComponent extends StatefulWidget {
  final String selectedShape;
  final Function(String) onShapeSelected;
  final bool isWarning;
  final Function(bool) onWarningChanged;

  const ShapeComponent(
      {super.key,
        required this.selectedShape,
        required this.onShapeSelected,
        required this.isWarning,
        required this.onWarningChanged});

  @override
  ShapeState createState() => ShapeState();
}

class ShapeState extends State<ShapeComponent> {
  final Set<String> buttonTexts = {
    '원형',
    '타원형',
    '삼각형',
    '사각형',
    '오각형',
    '육각형',
    '팔각형',
    '반원형',
    '기타'
  }; //알약 종류

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '(필수) 알약의 모양을 선택해주세요.',
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
        Wrap(
          spacing: 10,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: buttonTexts
              .map(
                (text) => OutlinedButton(
              onPressed: () {
                widget.onShapeSelected(text);
                if (widget.isWarning == true) {
                  widget.onWarningChanged(false);
                }
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor:
                widget.selectedShape == text ? backColor : whiteColor,
                side: const BorderSide(color: backColor),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 48),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: widget.selectedShape == text
                          ? whiteColor
                          : blackColor,
                      fontFamily: 'NotoSans500',
                      fontSize: 14),
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

//알약 식별표시 작성
class MarkComponent extends StatefulWidget {
  final String frontMark;
  final String backMark;
  final Function(String) onFrontMarkChanged;
  final Function(String) onBackMarkChanged;

  const MarkComponent(
      {super.key,
        required this.frontMark,
        required this.backMark,
        required this.onFrontMarkChanged,
        required this.onBackMarkChanged});

  @override
  MarkState createState() => MarkState();
}

class MarkState extends State<MarkComponent> {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();

  @override
  void initState() {
    super.initState();
    frontController.text = widget.frontMark;
    backController.text = widget.backMark;
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    super.dispose();
  }

  Widget buildMark(String title, TextEditingController controller,
      Function(String) onMarkChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, left: 12, right: 12, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'NotoSans500',
                fontSize: 14,
                color: backColor,
              ),
            ),
          ),
          TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: title,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: inputColor,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              style: const TextStyle(
                fontFamily: 'NotoSans500',
                fontSize: 14,
                color: blackColor,
              ),
              onChanged: onMarkChanged),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 20, top: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '(권장) 알약의 식별표시를 입력해주세요.',
              style: TextStyle(
                color: backColor,
                fontFamily: 'NotoSans500',
                fontSize: 14,
              ),
            ),
          ),
        ),
        const Divider(
          color: backColor,
          thickness: 1,
          height: 0,
          indent: 0,
        ),
        buildMark("식별표시 앞", frontController, widget.onFrontMarkChanged),
        buildMark("식별표시 뒤", backController, widget.onBackMarkChanged),
      ],
    );
  }
}
