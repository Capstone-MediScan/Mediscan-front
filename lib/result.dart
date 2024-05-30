import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediscan/data.dart';
import 'package:mediscan/main.dart';
import 'package:mediscan/theme/colors.dart';
import 'package:http/http.dart' as http;

class MedicineModel {
  final String pillId;
  final String pillName;
  final String pillNameEng;
  final String detail;
  final String? frontMarking;
  final String? backMarking;
  final String shape;
  final String width;
  final String length;
  final String thick;
  final String entpName;

  MedicineModel({
    required this.pillId,
    required this.pillName,
    required this.pillNameEng,
    required this.detail,
    this.frontMarking,
    this.backMarking,
    required this.shape,
    required this.width,
    required this.length,
    required this.thick,
    required this.entpName,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      pillId: json["pillId"] ?? '',
      pillName: json["pillName"] ?? '',
      pillNameEng: json["pillNameEng"] ?? '',
      detail: json["detail"] ?? '',
      frontMarking: json["frontMarking"],
      backMarking: json["backMarking"],
      shape: json["shape"] ?? '',
      width: json["width"] ?? '',
      length: json["length"] ?? '',
      thick: json["thick"] ?? '',
      entpName: json["entpName"] ?? '',
    );
  }
}

class ResultPage extends StatefulWidget {
  final String selectedId;
  final String selectImage;

  const ResultPage(
      {super.key, required this.selectedId, required this.selectImage});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  MedicineModel medicine = MedicineModel(
    pillId: '',
    pillName: '',
    pillNameEng: '',
    detail: '',
    frontMarking: '',
    backMarking: '',
    shape: '',
    width: '',
    length: '',
    thick: '',
    entpName: '',
  );
  bool inList = false;

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    final url =
        Uri.parse('${dotenv.env['PROJECT_URL']}/pill/${widget.selectedId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedResponse);

      setState(() {
        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          medicine = MedicineModel.fromJson(jsonResponse['data']);
        } else {
          medicine = MedicineModel(
            pillId: '',
            pillName: '',
            pillNameEng: '',
            detail: '',
            frontMarking: '',
            backMarking: '',
            shape: '',
            width: '',
            length: '',
            thick: '',
            entpName: '',
          );
        }
      });
      recentSearchPill();
    } else {}
  }

  Future<void> recentSearchPill() async {
    List<ResultListModel> pillList = await loadPillList();

    int existingIndex =
        pillList.indexWhere((pill) => pill.pillId == medicine.pillId);

    if (existingIndex != -1) {
      ResultListModel existingPill = pillList.removeAt(existingIndex);
      pillList.add(existingPill);
    } else {
      if (pillList.length >= 5) {
        pillList.removeAt(0);
      }
      pillList.add(ResultListModel(
        pillId: medicine.pillId,
        pillName: medicine.pillName,
        itemImage: widget.selectImage,
        className: medicine.detail,
      ));
    }
    await savePillList(pillList);
  }

  void toggleInList() {
    setState(() {
      inList = !inList;
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
                  BackBtnComponent(inList: inList, toggleInList: toggleInList),
                  ResultComponent(
                    medicine: medicine,
                    selectImage: widget.selectImage,
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
  final MedicineModel medicine;
  final String selectImage;

  const ResultComponent(
      {super.key, required this.medicine, required this.selectImage});

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
            top: 9,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.selectImage == ""
                    ? Container(
                        width: 290,
                        height: 155,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: mainColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                    : Image.network(
                        widget.selectImage,
                        width: 290,
                        height: 155,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Text(
                  widget.medicine.pillName,
                  style: const TextStyle(
                    color: blackColor,
                    fontFamily: 'NotoSans900',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        listContent('이름 ( 영문 )', widget.medicine.pillNameEng),
        widget.medicine.frontMarking == null &&
                widget.medicine.backMarking != null
            ? listContent('식별표시 뒤', "${widget.medicine.backMarking}")
            : widget.medicine.frontMarking != null &&
                    widget.medicine.backMarking == null
                ? listContent('식별표시 앞', "${widget.medicine.frontMarking}")
                : widget.medicine.frontMarking != null &&
                        widget.medicine.backMarking != null
                    ? listContent('식별표시 앞 / 뒤',
                        "${widget.medicine.frontMarking} / ${widget.medicine.backMarking}")
                    : const Column(),
        listContent('외형', widget.medicine.detail),
        listContent('길이 (가로, 세로, 두께) ( mm )',
            "${widget.medicine.width} / ${widget.medicine.length} / ${widget.medicine.thick}"),
        listContent('회사', widget.medicine.entpName),
        const SizedBox(height: 20),
      ],
    );
  }
}
