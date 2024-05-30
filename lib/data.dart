import 'package:mediscan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> savePillList(List<ResultListModel> pillList) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> jsonList =
      pillList.map((pill) => json.encode(pill.toJson())).toList();
  await prefs.setStringList('pillList', jsonList);
}

Future<List<ResultListModel>> loadPillList() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('pillList');

  if (jsonList == null) {
    return [];
  }

  return jsonList
      .map((jsonString) => ResultListModel.fromJson(json.decode(jsonString)))
      .toList();
}
