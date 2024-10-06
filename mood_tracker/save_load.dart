import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

Future<String> _getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/data.csv';
  return path;
}

Future<void> saveUserData(List<List<dynamic>> userData) async {
  final path = await _getFilePath();
  final file = File(path);

  String csvData = ListToCsvConverter().convert(userData);

  await file.writeAsString(csvData);
}

Future<List<List<dynamic>>> loadUserData() async {
  final path = await _getFilePath();
  final file = File(path);

  if (!await file.exists()) {
    return []; 
  }

  final csvString = await file.readAsString();
  final List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

  return csvTable;
}

Future<void> addUser(String email, String password) async {
  final userData = await loadUserData();

  for (var user in userData) {
    if (user.isNotEmpty && user[0] == email) {
      throw Exception('User with this email already exists');
    }
  }

  userData.add([email, password]);
  await saveUserData(userData);
}