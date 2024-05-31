import 'package:flutter/material.dart';
import 'package:mediscan/data.dart';
import 'package:mediscan/result.dart';
import 'package:mediscan/theme/colors.dart';

class ResultListModel {
  final String pillId;
  final int confidence;
  final String itemImage;
  final String pillName;
  final String className;

  ResultListModel({
    required this.pillId,
    required this.confidence,
    required this.itemImage,
    required this.pillName,
    required this.className,
  });
}

class SelectPage extends StatefulWidget {
  final List<dynamic> responseData;

  const SelectPage({super.key, required this.responseData});

  @override
  SelectPageState createState() => SelectPageState();
}

class SelectPageState extends State<SelectPage> {
  bool isWarning = false; //경고 색상 표시 여부
  String selectedId = ""; //선택된 ID 값

  late List<ResultListModel> scanResults;

  @override
  void initState() {
    super.initState();
    scanResults = widget.responseData.map((data) {
      return ResultListModel(
        pillId: data['pillId'],
        confidence: data['confidence'],
        itemImage: data['itemImage'],
        pillName: data['pillName'],
        className: data['className'],
      );
    }).toList();
  }

  void setWarning(bool warning) {
    setState(() {
      isWarning = warning;
    });
  }

  void setCapsule(String id) {
    setState(() {
      selectedId = id;
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
                  PhotoComponent(
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                    selectImage: selectedId != ""
                        ? scanResults
                        .firstWhere((result) => result.pillId == selectedId)
                        .itemImage
                        : "",
                  ),
                  CapsuleSelect(
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                    selectedId: selectedId,
                    onIdSelected: setCapsule,
                    buttonTexts: scanResults,
                  ),
                  ResultButton(
                    selectedId: selectedId,
                    selectImage: selectedId != ""
                        ? scanResults
                        .firstWhere((result) => result.pillId == selectedId)
                        .itemImage
                        : "",
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
  final String selectImage;

  const PhotoComponent({
    super.key,
    required this.isWarning,
    required this.onWarningChanged,
    required this.selectImage,
  });

  @override
  PhotoState createState() => PhotoState();
}

class PhotoState extends State<PhotoComponent> {
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          widget.selectImage != ""
              ? SizedBox(
            width: 290,
            height: 155,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: widget.selectImage == ""
                  ? null
                  : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.selectImage),
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
          )
              : Container(
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
          ),
        ]),
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
  final String selectedId;
  final Function(String) onIdSelected;
  final bool isWarning;
  final Function(bool) onWarningChanged;
  final List<ResultListModel> buttonTexts;

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
                      widget.onIdSelected(data.pillId);
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
                          color: widget.selectedId == data.pillId
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
                          '${data.confidence}%',
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
                          width: 74.84,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: data.itemImage == ""
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
                                : Image.network(
                              data.itemImage,
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
                              width: 160,
                              child: Text(
                                data.pillName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: blackColor,
                                    fontFamily: 'NotoSans500',
                                    fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                data.className,
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
  final String selectedId;
  final String selectImage;
  final bool isWarning;
  final Function(bool) onWarningChanged;

  const ResultButton(
      {super.key,
        required this.selectedId,
        required this.isWarning,
        required this.onWarningChanged,
        required this.selectImage});

  @override
  ResultButtonState createState() => ResultButtonState();
}

class ResultButtonState extends State<ResultButton> {
  void onResultPage() async {
    if (widget.selectedId == "") {
      widget.onWarningChanged(true);
    } else {
      MedicineModel? medicine = await fetchSearchResult(widget.selectedId);
      bool inList = await alreadyPillList(widget.selectedId);
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ResultPage(medicine: medicine, inList: inList),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
            opaque: false,
            barrierColor: Colors.transparent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 38, right: 38),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onResultPage,
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
