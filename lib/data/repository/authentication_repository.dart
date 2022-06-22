import 'dart:async';
import 'dart:convert';

import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_api_request.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_type.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

import 'shared_preferences_repository.dart';

class AuthenticationRepository extends BaseApiRequest {
  AuthenticationRepository();

  Future<bool> requestToken(String email) async {
    final response =
        await makeRequest(path: 'auth/register-request/', requestType: RequestType.post, data: {
      'email': email,
    }, extraHeaders: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    });
    return response.statusCode == 200;
  }

  Future<dynamic> logIn(String email, String password) async {
    final response =
        await makeRequest(path: 'auth/login/', requestType: RequestType.post, extraHeaders: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    }, data: {
      'email': email,
      'password': password
    });
    var userData = UserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    userData.userId = email;
    await SharedPreferencesRepository().addUserData(userData);
    return userData;
  }

  Future<dynamic> register(
      String email, String password, String passwordConfirm, String code) async {
    final response =
        await makeRequest(path: 'auth/register/', requestType: RequestType.post, extraHeaders: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    }, data: {
      'verification_code': code,
      'email': email,
      'password': password,
      'password_confirm': passwordConfirm,
    });
    final userData = UserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    await SharedPreferencesRepository().addUserData(userData);
    return userData;
  }
}

class AuthData {
  String username;
  String password;

  AuthData({required this.username, required this.password});
}
