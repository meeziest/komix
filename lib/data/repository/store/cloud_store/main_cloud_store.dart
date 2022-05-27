import 'dart:convert';

import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_user_api_request.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_type.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/project_data.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

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
}
