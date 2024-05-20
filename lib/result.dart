import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/theme/colors.dart';

class Medicine {
  final int id;
  final File? image;
  final String title;
  final String nameInEn;
  final String efficacy;
  final String frontMark;
  final String backMark;
  final String appearance;
  final double width;
  final double height;
  final double thickness;
  final String company;
  bool inList;

  Medicine({
    required this.id,
    this.image,
    required this.title,
    required this.nameInEn,
    required this.efficacy,
    required this.frontMark,
    required this.backMark,
    required this.appearance,
    required this.width,
    required this.height,
    required this.thickness,
    required this.company,
    required this.inList,
  });
}

class ResultPage extends StatefulWidget {
  final int selectedId;

  const ResultPage({super.key, required this.selectedId});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  Medicine medicine = Medicine(
    id: 1,
    image: null,
    title: '리피논정 80밀리그램 (아토르바스타틴칼슘삼수화물)',
    nameInEn: 'lipinon tablet 80mg (Atorvastatin calcium trihydrate)',
    efficacy: '동맥경화용재',
    frontMark: 'LPT',
    backMark: '80',
    appearance: '이 약은 흰색의 타원형 필름코팅정이다.',
    width: 19.55,
    height: 10.50,
    thickness: 7.06,
    company: '동아에스티 (주)',
    inList: false,
  );

  void toggleInList() {
    setState(() {
      medicine.inList = !medicine.inList;
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
                  BackBtnComponent(
                      inList: medicine.inList, toggleInList: toggleInList),
                  ResultComponent(medicine: medicine)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackBtnComponent extends StatefulWidget {
  final bool inList;
  final VoidCallback toggleInList;

  const BackBtnComponent(
      {super.key, required this.inList, required this.toggleInList});

  @override
  BackBtnState createState() => BackBtnState();
}

class BackBtnState extends State<BackBtnComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 65,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/back.png',
                    width: 9,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  highlightColor: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.toggleInList();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.inList ? deleteColor : mainColor,
                    foregroundColor: widget.inList ? deleteColor : mainColor,
                    surfaceTintColor: widget.inList ? deleteColor : mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    widget.inList ? '리스트에서 삭제' : '리스트에 추가',
                    style: const TextStyle(
                      fontFamily: 'NotoSans500',
                      fontSize: 14,
                      color: whiteColor,
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

class ResultComponent extends StatefulWidget {
  final Medicine medicine;

  const ResultComponent({super.key, required this.medicine});

  @override
  ResultState createState() => ResultState();
}

class ResultState extends State<ResultComponent> {
  Widget listContent(
    String title,
    String content,
  ) {
    return Column(children: [
      const Divider(
        color: backColor,
        thickness: 1,
        height: 0,
        indent: 0,
      ),
      Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: blackColor,
                    fontFamily: 'NotoSans900',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: const TextStyle(
                    color: blackColor,
                    fontFamily: 'NotoSans500',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.medicine.image == null
                    ? Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: mainColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                    : Image.file(
                        widget.medicine.image!,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 158,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    widget.medicine.title,
                    style: const TextStyle(
                      color: blackColor,
                      fontFamily: 'NotoSans900',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        listContent('이름 ( 영문 )', widget.medicine.nameInEn),
        listContent('효능', widget.medicine.efficacy),
        listContent('식별표시 앞 / 뒤',
            "${widget.medicine.frontMark} / ${widget.medicine.backMark}"),
        listContent('외형', widget.medicine.appearance),
        listContent('길이 (가로, 세로, 두께) ( mm )',
            "${widget.medicine.width} / ${widget.medicine.height} / ${widget.medicine.thickness}"),
        listContent('회사', widget.medicine.company),
        const SizedBox(height: 68),
      ],
    );
  }
}
