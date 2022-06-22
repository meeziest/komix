import 'dart:convert';

import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_user_api_request.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_type.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/page_data.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/project_data.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';

class MainCloudStore extends BaseUserApiRequest {
  MainCloudStore(UserData userData) : super(userData);

  Future<ProjectData> createProject(String title, String description) async {
    final response =
        await makeRequest(path: 'project/', requestType: RequestType.post, extraHeaders: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    }, data: {
      'title': title,
      'description': description
    });
    var projectData = ProjectData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return projectData;
  }

  Future<ProjectData> getPages(String code, {PageType? type}) async {
    String pageType = type != null ? type.string : 'original';
    final response =
        await makeRequest(path: 'project/$code/', requestType: RequestType.get, extraHeaders: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    }, queryParameters: {
      'status': pageType,
    });
    var projectData = ProjectData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return projectData;
  }

  Future<ProjectData> scanText(String code, {String? lang}) async {
    String textLang = lang ?? 'en';
    final response =
        await makeRequest(path: 'project/$code/scan', requestType: RequestType.get, extraHeaders: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    }, queryParameters: {
      'lang': textLang,
    });
    var projectData = ProjectData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return projectData;
  }

  Future<PageData> reInject(String projectCode, PageData pageData) async {
    final response = await makeRequest(
        path: 'project/$projectCode/reinject',
        requestType: RequestType.post,
        extraHeaders: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        data: pageData.toJson());
    var newPageData = PageData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return newPageData;
  }
}
