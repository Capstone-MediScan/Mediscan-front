import 'package:flutter/material.dart';
import 'package:mediscan/selectsearchresult.dart';
import 'package:mediscan/theme/colors.dart';

class CapsuleSearch extends StatefulWidget {
  const CapsuleSearch({super.key});

  @override
  CapsuleSearchState createState() => CapsuleSearchState();
}

class CapsuleSearchState extends State<CapsuleSearch> {
  String selectedShape = ''; //선택한 알약 모양
  String frontMark = ''; //작성한 식별표시 앞
  String backMark = ''; //작성한 식별표시 뒤
  String selectedColor = ''; //선택한 알약 색상
  bool isWarning = false; //경고 색상 표시 여부

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

  void setSelectedColor(String color) {
    setState(() {
      selectedColor = color;
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
                  Container(
                    height: 65,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            '식별표시검색',
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
                  MarkComponent(
                    frontMark: frontMark,
                    backMark: backMark,
                    onFrontMarkChanged: setFrontMark,
                    onBackMarkChanged: setBackMark,
                  ),
                  ShapeComponent(
                    selectedShape: selectedShape,
                    onShapeSelected: setSelectedShape,
                  ),
                  ColorComponent(
                    selectedColor: selectedColor,
                    setSelectedColor: setSelectedColor,
                  ),
                  const SizedBox(height: 120),
                  if (isWarning)
                    const Text(
                      '식별표시 앞 뒤 , 모양 , 색상을 모두 입력해 주세요.',
                      style: TextStyle(
                        fontFamily: 'NotoSans500',
                        fontSize: 12,
                        color: redColor,
                      ),
                    ),
                  SearchButton(
                    buttonText: "결과 확인하기",
                    selectedShape: selectedShape,
                    frontMark: frontMark,
                    backMark: backMark,
                    selectedColor: selectedColor,
                    isWarning: isWarning,
                    onWarningChanged: setWarning,
                    onPressed: () {
                      if (selectedShape == '' ||
                          selectedColor == '' ||
                          frontMark == '' ||
                          backMark == '') {
                        setWarning(true);
                      } else {
                        // ShapeData data = ShapeData(
                        //   selectedShape: selectedShape,
                        //   frontMark: frontMark,
                        //   backMark: backMark,
                        //   selectedColor: selectedColor,
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectSearchPage(),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Text('$selectedShape $frontMark $backMark $selectedColor'),
        ],
      ),
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
        buildMark("식별표시 앞", frontController, widget.onFrontMarkChanged),
        buildMark("식별표시 뒤", backController, widget.onBackMarkChanged),
      ],
    );
  }
}

//알약 모양 선택
class ShapeComponent extends StatefulWidget {
  final String selectedShape;
  final Function(String) onShapeSelected;

  const ShapeComponent({
    super.key,
    required this.selectedShape,
    required this.onShapeSelected,
  });

  @override
  ShapeState createState() => ShapeState();
}

class ShapeState extends State<ShapeComponent> {
  final Map<String, String> buttonTexts = {
    '원형': 'circle',
    '타원형': 'ellipse',
    '삼각형': 'triangle',
    '사각형': 'square',
    '오각형': 'pentagon',
    '육각형': 'hexagon',
    '팔각형': 'octagon',
    '다이아몬드': 'diamond',
    '기타': 'etc'
  }; //알약 종류

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16, left: 20, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '모양',
              style: TextStyle(
                color: backColor,
                fontFamily: 'NotoSans500',
                fontSize: 14,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: buttonTexts.entries
              .map(
                (entry) => OutlinedButton(
                  onPressed: () {
                    widget.onShapeSelected(entry.value);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: widget.selectedShape == entry.value
                        ? backColor
                        : whiteColor,
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
                      entry.key,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.selectedShape == entry.value
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

//알약 색상 선택
class ColorComponent extends StatefulWidget {
  final String selectedColor;
  final Function(String) setSelectedColor;

  const ColorComponent({
    super.key,
    required this.selectedColor,
    required this.setSelectedColor,
  });

  @override
  ColorState createState() => ColorState();
}

class ColorState extends State<ColorComponent> {
  final Map<String, String> buttonTexts = {
    '#FFFFFF': '하양',
    '#FFFB9B': '노랑',
    '#F9C84B': '주황',
    '#FFD2D2': '분홍',
    '#FF6A6A': '빨강',
    '#925700': '갈색',
    '#D3FFA8': '연두',
    '#84A674': '초록',
    '#86E6EC': '청록',
    '#609CE2': '파랑',
    '#395CD7': '남색',
    '#B25286': '자주',
    '#FF079C': '보라',
    '#B9B9B9': '회색',
    '#000000': '검정',
  }; //알약 색상 종류

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16, left: 20, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '색상',
              style: TextStyle(
                color: backColor,
                fontFamily: 'NotoSans500',
                fontSize: 14,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Wrap(
            spacing: 8,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: buttonTexts.entries
                .map(
                  (entry) => SizedBox(
                    width: 30,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () {
                        widget.setSelectedColor(entry.value);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Color(
                            int.parse(entry.key.replaceFirst('#', '0xff'))),
                        foregroundColor: Color(
                            int.parse(entry.key.replaceFirst('#', '0xff'))),
                        surfaceTintColor: Color(
                            int.parse(entry.key.replaceFirst('#', '0xff'))),
                        side: BorderSide(
                            color: widget.selectedColor == entry.value
                                ? blackColor
                                : backColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: null,
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}

class ShapeData {
  final String selectedShape; //선택한 알약 모양
  final String frontMark; //작성한 식별표시 앞
  final String backMark; //작성한 식별표시 뒤
  final String selectedColor; //선택한 알약 색상

  ShapeData({
    required this.selectedShape,
    required this.frontMark,
    required this.backMark,
    required this.selectedColor,
  });
}

class SearchButton extends StatefulWidget {
  final String buttonText;
  final String selectedShape;
  final String frontMark;
  final String backMark;
  final String selectedColor;
  final Function() onPressed;
  final bool isWarning;
  final Function(bool) onWarningChanged;

  const SearchButton(
      {super.key,
      required this.buttonText,
      required this.selectedShape,
      required this.frontMark,
      required this.backMark,
      required this.selectedColor,
      required this.onPressed,
      required this.isWarning,
      required this.onWarningChanged});

  @override
  SearchButtonState createState() => SearchButtonState();
}

class SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 38, right: 38, top: 50),
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
