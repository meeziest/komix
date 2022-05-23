import 'dart:async';
import 'dart:convert';

import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_api_request.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_type.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class UserRepository extends BaseApiRequest {
  static final Map<String, UserRepository> _instance = {};
  UserData userData;

  UserRepository._internal(this.userData) {
    _instance[userData.uniqueId] = this;
  }

  factory UserRepository(UserData userData) =>
      _instance[userData.userId] ?? UserRepository._internal(userData);

  Future<UserData> getUser() async {
    final response =
        await makeRequest(path: 'client/r0/userData', requestType: RequestType.post, data: {
      'token': this.userData.accessToken,
    });
    final userData = UserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    await SharedPreferencesRepository().addUserData(userData);
    return userData;
  }

  Future<bool> deleteToken() async {
    final response =
        await makeRequest(path: 'client/r0/deleteToken', requestType: RequestType.post, data: {
      'token': userData.accessToken,
    });
    return response.statusCode == 200;
  }

  Future<bool> persistToken(String token) async {
    final response =
        await makeRequest(path: 'client/r0/persist', requestType: RequestType.post, data: {
      'token': this.userData.accessToken,
    });
    final userData = UserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    SharedPreferencesRepository().addUserData(userData);
    return response.statusCode == 200;
  }

  Future<bool> hasToken() async {
    final response =
        await makeRequest(path: 'client/r0/hasToken', requestType: RequestType.post, data: {
      'email': userData.userId,
    });
    return response.statusCode == 200;
  }

  Future clearDb() {
    return SharedPreferencesRepository().clearUserData();
  }
}
