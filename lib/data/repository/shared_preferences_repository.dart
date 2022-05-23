// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:simple_manga_translation/domain/objects/profile_data.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

const String _PUSH_TOKEN = 'push_token';
const String _USER_DATA = 'user_data';
const String _PROFILE_DATA = 'profile_data';

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

  String? getPushToken(String user) {
    try {
      String? token = _prefs.getString('$_PUSH_TOKEN-$user');
      return token;
    } catch (e) {
      return null;
    }
  }

  Future addUserData(UserData userData) async {
    List<UserData> users = getUserData();
    users.add(userData);
    return _prefs.setStringList(_USER_DATA,
        List<String>.generate(users.length, (index) => jsonEncode(users[index].toJson())));
  }

  Future addProfileData(ProfileData profileData) async {
    List<ProfileData> profiles = getProfileData();
    profiles.add(profileData);
    return _prefs.setStringList(_PROFILE_DATA,
        List<String>.generate(profiles.length, (index) => jsonEncode(profiles[index].toJson())));
  }

  List<ProfileData> getProfileData() {
    List<String> listJson = _prefs.getStringList(_PROFILE_DATA) ?? [];
    if (listJson.isEmpty) {
      return [];
    } else {
      bool needRewrite = false;
      List<ProfileData> result = [];
      for (var element in listJson) {
        try {
          final profileData = ProfileData.fromJson(jsonDecode(element));
          result.add(profileData);
        } catch (e) {
          needRewrite = true;
        }
      }
      if (needRewrite) {
        _prefs.setStringList(_PROFILE_DATA,
            List<String>.generate(result.length, (index) => jsonEncode(result[index].toJson())));
      }
      return result;
    }
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
