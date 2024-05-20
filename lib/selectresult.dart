import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/result.dart';
import 'package:mediscan/theme/colors.dart';

class ResultList {
  final int id;
  final int percent;
  final File? image;
  final File? frontImage; //약 이미지 앞
  final File? backImage; //약 이미지 뒤
  final String title;
  final String description;

  ResultList({
    required this.id,
    required this.percent,
    this.image,
    this.frontImage,
    this.backImage,
    required this.title,
    required this.description,
  });
}

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  SelectPageState createState() => SelectPageState();
}

class SelectPageState extends State<SelectPage> {
  bool isWarning = false; //경고 색상 표시 여부
  int selectedId = 0; //선택된 ID 값

  List<ResultList> buttonTexts = [
    ResultList(
      id: 1,
      percent: 67,
      image: null,
      frontImage: null,
      backImage: null,
      title: '리피논정 80밀리그램 (지토르 어찌지)',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 2,
      percent: 67,
      image: null,
      frontImage: null,
      backImage: null,
      title: '리피논정 80밀리그램 (아토르 어찌구)',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 3,
      percent: 67,
      image: null,
      frontImage: null,
      backImage: null,
      title: '리피논정 80밀리그램',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 4,
      percent: 67,
      image: null,
      frontImage: null,
      backImage: null,
      title: '리피논정 80밀리그램',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 5,
      percent: 67,
      image: null,
      frontImage: null,
      backImage: null,
      title: '리피논정 80밀리그램 (아토르 어찌구)',
      description: '전립선비대증약',
    ),
  ];

  void setWarning(bool warning) {
    setState(() {
      isWarning = warning;
    });
  }

  void setCapsule(int id) {
    setState(() {
      selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        title: const Text(
          'MediScan',
          style:
              TextStyle(color: mainColor, fontFamily: 'Inter900', fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PhotoComponent(
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                    frontImage: selectedId != 0
                        ? buttonTexts
                            .firstWhere((result) => result.id == selectedId)
                            .frontImage
                        : null,
                    backImage: selectedId != 0
                        ? buttonTexts
                            .firstWhere((result) => result.id == selectedId)
                            .backImage
                        : null,
                  ),
                  CapsuleSelect(
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                    selectedId: selectedId,
                    onIdSelected: setCapsule,
                    buttonTexts: buttonTexts,
                  ),
                  ResultButton(
                    selectedId: selectedId,
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoComponent extends StatefulWidget {
  final bool isWarning;
  final Function(bool) onWarningChanged;
  final File? frontImage;
  final File? backImage;

  const PhotoComponent(
      {super.key,
      required this.isWarning,
      required this.onWarningChanged,
      this.frontImage,
      this.backImage});

  @override
  PhotoState createState() => PhotoState();
}

class PhotoState extends State<PhotoComponent> {
  Widget buildImage(File? image) {
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image == null
                ? null
                : Container(
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          alignment: Alignment.center,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '검색 결과',
                  style: TextStyle(
                    color: blackColor,
                    fontFamily: 'NotoSans700',
                    fontSize: 20,
                  ),
                ),
              ),
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.frontImage != null
                ? buildImage(widget.frontImage)
                : Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: mainColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
            const SizedBox(width: 30),
            widget.backImage != null
                ? buildImage(widget.backImage)
                : Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: mainColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 16),
          child: Text(
            '알약을 선택해 주세요.',
            style: TextStyle(
              color: widget.isWarning ? redColor : backColor,
              fontFamily: 'NotoSans500',
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }
}

class CapsuleSelect extends StatefulWidget {
  final int selectedId;
  final Function(int) onIdSelected;
  final bool isWarning;
  final Function(bool) onWarningChanged;
  final List<ResultList> buttonTexts;

  const CapsuleSelect({
    super.key,
    required this.selectedId,
    required this.onIdSelected,
    required this.isWarning,
    required this.onWarningChanged,
    required this.buttonTexts,
  });

  @override
  CapsuleSelectState createState() => CapsuleSelectState();
}

class CapsuleSelectState extends State<CapsuleSelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.buttonTexts.map(
        (data) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onIdSelected(data.id);
                      if (widget.isWarning == true) {
                        widget.onWarningChanged(false);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: whiteColor,
                      foregroundColor: whiteColor,
                      side: BorderSide(
                          color: widget.selectedId == data.id
                              ? mainColor
                              : subColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 27, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${data.percent}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: mainColor,
                              fontFamily: 'Inter900',
                              fontSize: 24),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: data.image == null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: mainColor,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                                : Image.file(
                                    data.image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 190,
                              child: Text(
                                data.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: blackColor,
                                    fontFamily: 'NotoSans500',
                                    fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: 190,
                              child: Text(
                                data.description,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: backColor,
                                    fontFamily: 'NotoSans500',
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}

class ResultButton extends StatefulWidget {
  final int selectedId;
  final bool isWarning;
  final Function(bool) onWarningChanged;

  const ResultButton(
      {super.key,
      required this.selectedId,
      required this.isWarning,
      required this.onWarningChanged});

  @override
  ResultButtonState createState() => ResultButtonState();
}

class ResultButtonState extends State<ResultButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 38, right: 38),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (widget.selectedId == 0) {
                  widget.onWarningChanged(true);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ResultPage(selectedId: widget.selectedId),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '정보 확인하기',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'NotoSans500', fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}