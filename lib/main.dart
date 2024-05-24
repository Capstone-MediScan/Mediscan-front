import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/capsulelist.dart';
import 'package:mediscan/capsulescan.dart';
import 'package:mediscan/capsulesearch.dart';
import 'package:mediscan/result.dart';
import 'package:mediscan/theme/colors.dart';

class ResultList {
  final int id;
  final int percent;
  final File? image;
  final String title;
  final String description;

  ResultList({
    required this.id,
    required this.percent,
    this.image,
    required this.title,
    required this.description,
  });
}

void main() => runApp(MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: whiteColor),
      home: const MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePage(),
      const CapsuleListPage(),
      const CapsuleListPage(),
      const CapsuleListPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 65,
        title: const Text(
          'MediScan',
          style:
              TextStyle(color: mainColor, fontFamily: 'Inter900', fontSize: 24),
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: mainColor,
        unselectedItemColor: backColor,
        selectedLabelStyle:
            const TextStyle(fontFamily: 'NotoSans500', fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'NotoSans500', fontSize: 12),
        backgroundColor: whiteColor,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '홈',
            icon: Image.asset(
              'assets/images/home.png',
              width: 30,
            ),
            activeIcon: Image.asset(
              'assets/images/homeSelected.png',
              width: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: '리스트',
            icon: Image.asset(
              'assets/images/list.png',
              width: 30,
            ),
            activeIcon: Image.asset(
              'assets/images/listSelected.png',
              width: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: '알림',
            icon: Image.asset(
              'assets/images/alert.png',
              width: 30,
            ),
            activeIcon: Image.asset(
              'assets/images/alertSelected.png',
              width: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'my',
            icon: Image.asset(
              'assets/images/my.png',
              width: 30,
            ),
            activeIcon: Image.asset(
              'assets/images/mySelected.png',
              width: 30,
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<ResultList> list = [
    ResultList(
      id: 1,
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램 (아토르바스타틴칼슘삼어찌고어라라라)',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 2,
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램 (아토르 어찌구)',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 3,
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 4,
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램',
      description: '전립선비대증약',
    ),
    ResultList(
      id: 5,
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램 (아토르 어찌구)',
      description: '전립선비대증약',
    ),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              const PageBtnComponent(),
              const SizedBox(height: 87),
              const RecentSearchComponent(),
              RecentSearchListComponent(list: list),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ],
    );
  }
}

class PageBtnComponent extends StatefulWidget {
  const PageBtnComponent({super.key});

  @override
  PageBtnState createState() => PageBtnState();
}

class PageBtnState extends State<PageBtnComponent> {
  Widget pageButton(
    String image,
    String title,
    String content,
    Widget Function() destinationWidgetBuilder,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => destinationWidgetBuilder(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: subColor,
              foregroundColor: subColor,
              surfaceTintColor: subColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(left: 17, top: 10, bottom: 10),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  image,
                  width: 85,
                  height: 85,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'NotoSans700',
                          fontSize: 20,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        content,
                        style: const TextStyle(
                          fontFamily: 'NotoSans700',
                          fontSize: 12,
                          color: backColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pageButton(
          "assets/images/scan.png",
          "알약 스캔",
          "알약을 스캔 또는 업로드하여 검색해보세요!",
          () => const CapsuleScan(),
        ),
        pageButton(
          "assets/images/search.png",
          "알약 검색",
          "알약을 카테고리를 활용하여 검색해보세요!",
          () => const CapsuleSearch(),
        ),
      ],
    );
  }
}

class RecentSearchComponent extends StatefulWidget {
  const RecentSearchComponent({super.key});

  @override
  RecentSearchState createState() => RecentSearchState();
}

class RecentSearchState extends State<RecentSearchComponent> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(
          color: backColor,
          thickness: 1,
          height: 0,
          indent: 0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '최근 검색 알약',
              style: TextStyle(
                color: mainColor,
                fontFamily: 'NotoSans700',
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RecentSearchListComponent extends StatefulWidget {
  final List<ResultList> list;

  const RecentSearchListComponent({super.key, required this.list});

  @override
  RecentSearchListState createState() => RecentSearchListState();
}

class RecentSearchListState extends State<RecentSearchListComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.list.map(
        (data) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      selectedId: data.id,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
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
                        width: 274,
                        child: Text(
                          data.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: blackColor,
                            fontFamily: 'NotoSans500',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 274,
                        child: Text(
                          data.description,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: backColor,
                            fontFamily: 'NotoSans500',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
