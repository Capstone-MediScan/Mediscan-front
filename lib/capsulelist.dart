import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediscan/result.dart';
import 'package:mediscan/theme/colors.dart';

class CapsuleListPage extends StatefulWidget {
  const CapsuleListPage({super.key});

  @override
  CapsuleListPageState createState() => CapsuleListPageState();
}

class CapsuleListPageState extends State<CapsuleListPage> {
  List<ResultList> list = [
    ResultList(
      id: "1",
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램 (아토르바스타틴칼슘삼어찌고어라라라)',
      description: '전립선비대증약',
    ),
    ResultList(
      id: "2",
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램 (아토르 어찌구)',
      description: '전립선비대증약',
    ),
    ResultList(
      id: "3",
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램',
      description: '전립선비대증약',
    ),
    ResultList(
      id: "4",
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램',
      description: '전립선비대증약',
    ),
    ResultList(
      id: "5",
      percent: 67,
      image: null,
      title: '리피논정 80밀리그램 (아토르 어찌구)',
      description: '전립선비대증약',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListComponent(list: list),
                ],
              ),
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
  final List<ResultList> list;

  const ListComponent({super.key, required this.list});

  @override
  ListState createState() => ListState();
}

class ListState extends State<ListComponent> {
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
                      selectImage: '',
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
                        width: 250,
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
                        width: 250,
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
