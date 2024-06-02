import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/data.dart';
import 'package:mediscan/main.dart';
import 'package:mediscan/result.dart';
import 'package:mediscan/theme/colors.dart';

class CapsuleListPage extends StatefulWidget {
  const CapsuleListPage({super.key});

  static final GlobalKey<CapsuleListPageState> globalKey = GlobalKey();

  @override
  CapsuleListPageState createState() => CapsuleListPageState();
}

class CapsuleListPageState extends State<CapsuleListPage> {
  late Future<List<ResultListModel>> addPillLists;

  @override
  void initState() {
    super.initState();
    addPillLists = loadPillList("addList");
  }

  Future<void> refresh() async {
    setState(() {
      addPillLists = loadPillList("addList");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ResultListModel>>(
              future: addPillLists,
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
                        ListComponent(list: snapshot.data!),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResultList {
  final String id;
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

class ListComponent extends StatefulWidget {
  final List<ResultListModel> list;

  const ListComponent({super.key, required this.list});

  @override
  ListState createState() => ListState();
}

class ListState extends State<ListComponent> {
  void onResultPage(String selectedId) async {
    MedicineModel? medicine = await fetchSearchResult(selectedId);
    bool inList = await alreadyPillList(selectedId);
    if (mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ResultPage(medicine: medicine, inList: inList),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
          opaque: false,
          barrierColor: Colors.transparent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.list.map(
        (data) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
            child: GestureDetector(
              onTap: () {
                onResultPage(data.pillId);
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
                        width: 230,
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
                        width: 230,
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
