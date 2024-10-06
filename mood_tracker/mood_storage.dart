import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getDataFile(String date) async {
    final path = await _localPath;
    return File('$path/$date.json');
  }

  static Future<Map<String, dynamic>> loadData(String date) async {
    try {
      final file = await _getDataFile(date);
      if (!await file.exists()) {
        return {};
      }
      final contents = await file.readAsString();
      return json.decode(contents);
    } catch (e) {
      print('Error reading data: $e');
      return {};
    }
  }

  static Future<void> saveData(String date, Map<String, dynamic> data) async {
    final file = await _getDataFile(date);
    await file.writeAsString(json.encode(data));
  }
}
