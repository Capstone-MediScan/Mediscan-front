import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediscan/main.dart';
import 'package:mediscan/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> savePillList(List<ResultListModel> pillList, String key) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> jsonList =
      pillList.map((pill) => json.encode(pill.toJson())).toList();
  await prefs.setStringList(key, jsonList);
}

Future<List<ResultListModel>> loadPillList(String key) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList(key);

  if (jsonList == null) {
    return [];
  }

  return jsonList
      .map((jsonString) => ResultListModel.fromJson(json.decode(jsonString)))
      .toList();
}

Future<MedicineModel> fetchSearchResult(String selectedId) async {
  final url = Uri.parse('${dotenv.env['PROJECT_URL']}/pill/$selectedId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final decodedResponse = utf8.decode(response.bodyBytes);
    final jsonResponse = json.decode(decodedResponse);
    return MedicineModel.fromJson(jsonResponse['data']);
  } else {
    return MedicineModel(
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
      itemImage: '',
    );
  }
}

Future<bool> alreadyPillList(String selectedId) async {
  List<ResultListModel> addList = await loadPillList("addList");

  int existingIndex = addList.indexWhere((pill) => pill.pillId == selectedId);

  return existingIndex != -1;
}
