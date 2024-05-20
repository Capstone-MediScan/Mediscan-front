import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/theme/colors.dart';

class ShapeData {
  final String selectedShape; //선택한 알약 모양
  final String frontMark; //작성한 식별표시 앞
  final String backMark; //작성한 식별표시 뒤
  File? frontImage; //약 이미지 앞
  File? backImage; //약 이미지 뒤

  ShapeData({
    required this.selectedShape,
    required this.frontMark,
    required this.backMark,
    this.frontImage,
    this.backImage,
  });
}

class LargeButton extends StatefulWidget {
  final String buttonText;
  final String selectedShape;
  final String frontMark;
  final String backMark;
  final Function() onPressed;
  final File? frontImage;
  final File? backImage;

  const LargeButton(
      {super.key,
      required this.buttonText,
      required this.selectedShape,
      required this.frontMark,
      required this.backMark,
      required this.onPressed,
      required this.frontImage,
      required this.backImage});

  @override
  LargeButtonState createState() => LargeButtonState();
}

class LargeButtonState extends State<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 38, right: 38),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.buttonText,
                style: const TextStyle(
                    color: whiteColor, fontFamily: 'NotoSans500', fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
