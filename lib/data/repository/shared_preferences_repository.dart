// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

const String _USER_DATA = 'user_data';
const String _PROJECT_SAVE_PATH = 'project_save_path';
const String _SERVER_URL = 'server_url';

class SharedPreferencesRepository {
  late SharedPreferences _prefs;

  static final SharedPreferencesRepository _preferencesRepository =
      SharedPreferencesRepository._internal();

  factory SharedPreferencesRepository() {
    return _preferencesRepository;
  }

  SharedPreferencesRepository._internal();

  Future<List<UserData>> init() async {
    _prefs = await SharedPreferences.getInstance();
    return getUserData();
  }

  String? getServerUrl() {
    return _prefs.getString(_SERVER_URL);
  }

  Future setServerUrl(String serverUrl) async {
    return _prefs.setString(_SERVER_URL, serverUrl);
  }

  Future setProjectSavePath(String savePath, UserData userData) async {
    return _prefs.setString('$_PROJECT_SAVE_PATH-${userData.userId}', savePath);
  }

  void cleanProjectSavePath(UserData userData) {
    _prefs.remove('$_PROJECT_SAVE_PATH-${userData.userId}');
  }

  String? getProjectSavePath(UserData userData) {
    return _prefs.getString('$_PROJECT_SAVE_PATH-${userData.userId}');
  }

  Future addUserData(UserData userData) async {
    List<UserData> users = getUserData();
    users.add(userData);
    return _prefs.setStringList(_USER_DATA,
        List<String>.generate(users.length, (index) => jsonEncode(users[index].toJson())));
  }

  List<UserData> getUserData() {
    List<String> listJson = _prefs.getStringList(_USER_DATA) ?? [];
    if (listJson.isEmpty) {
      return [];
    } else {
      bool needRewrite = false;
      List<UserData> result = [];
      for (var element in listJson) {
        try {
          final userData = UserData.fromJson(jsonDecode(element));
          result.add(userData);
        } catch (e) {
          needRewrite = true;
        }
      }
      if (needRewrite) {
        _prefs.setStringList(_USER_DATA,
            List<String>.generate(result.length, (index) => jsonEncode(result[index].toJson())));
      }
      return result;
    }
  }

  Future clearUserData() async {
    return _prefs.clear();
  }
}
