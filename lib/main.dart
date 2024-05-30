import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediscan/capsulelist.dart';
import 'package:mediscan/capsulescan.dart';
import 'package:mediscan/capsulesearch.dart';
import 'package:mediscan/custom.dart';
import 'package:mediscan/data.dart';
import 'package:mediscan/result.dart';
import 'package:mediscan/theme/colors.dart';
import 'package:mediscan/alertmain.dart';
import 'package:timezone/data/latest.dart' as tz;

class ResultListModel {
  final String pillId;
  final String pillName;
  final String itemImage;
  final String className;

  ResultListModel({
    required this.pillId,
    required this.pillName,
    required this.itemImage,
    required this.className,
  });

  Map<String, dynamic> toJson() {
    return {
      'pillId': pillId,
      'pillName': pillName,
      'itemImage': itemImage,
      'className': className,
    };
  }

  factory ResultListModel.fromJson(Map<String, dynamic> json) {
    return ResultListModel(
      pillId: json["pillId"] ?? '',
      pillName: json["pillName"] ?? '',
      itemImage: json["itemImage"] ?? '',
      className: json["className"] ?? '',
    );
  }
}

Future<void> main() async {
  tz.initializeTimeZones();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediScan',
      home: const Root(),
      theme: ThemeData(scaffoldBackgroundColor: whiteColor),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  int currentIndex = 0;
  late List<GlobalKey<NavigatorState>> navigatorKeyList;

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    navigatorKeyList = List.generate(3, (index) => GlobalKey<NavigatorState>());
    pages.addAll([
      HomePage(key: HomePage.globalKey),
      const CapsuleListPage(),
      const MediScanHome(),
    ]);
  }

  void reloadPillList() {
    setState(() {
      currentIndex = 0;
      navigatorKeyList[currentIndex]
          .currentState!
          .popUntil((route) => route.isFirst);
      HomePage.globalKey.currentState?.refresh();
    });
  }

  void handlePopEvent() {
    if (currentIndex == 0) {
      HomePage.globalKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await navigatorKeyList[currentIndex].currentState!.maybePop());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          scrolledUnderElevation: 0,
          toolbarHeight: 65,
          title: GestureDetector(
            onTap: () {
              reloadPillList();
            },
            child: const Text(
              'MediScan',
              style: TextStyle(
                  color: mainColor, fontFamily: 'Inter900', fontSize: 24),
            ),
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: pages.map((page) {
            int index = pages.indexOf(page);
            return Navigator(
              key: navigatorKeyList[index],
              onGenerateRoute: (_) {
                return MaterialPageRoute(
                  builder: (context) => page,
                  settings: RouteSettings(
                    arguments: CustomNavigatorObserver(
                      onPop: handlePopEvent,
                    ),
                  ),
                );
              },
              observers: [CustomNavigatorObserver(onPop: handlePopEvent)],
            );
          }).toList(),
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
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final GlobalKey<HomePageState> globalKey = GlobalKey();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<ResultListModel>> loadPillLists;

  @override
  void initState() {
    super.initState();
    loadPillLists = loadPillList();
  }

  Future<void> refresh() async {
    setState(() {
      loadPillLists = loadPillList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder<List<ResultListModel>>(
        future: loadPillLists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const PageBtnComponent(),
                  const SizedBox(height: 87),
                  const RecentSearchComponent(),
                  RecentSearchListComponent(list: snapshot.data ?? []),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
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
              HomePage.globalKey.currentState?.refresh();
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
  final List<ResultListModel> list;

  const RecentSearchListComponent({super.key, required this.list});

  @override
  RecentSearchListState createState() => RecentSearchListState();
}

class RecentSearchListState extends State<RecentSearchListComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.list.reversed.map(
        (data) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      selectedId: data.pillId,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 93.55,
                    height: 50,
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
                        width: 250,
                        child: Text(
                          data.pillName,
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
                        width: 250,
                        child: Text(
                          data.className,
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
