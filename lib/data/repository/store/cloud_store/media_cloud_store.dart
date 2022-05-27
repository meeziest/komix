import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_user_api_request.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/project_data.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class MediaCloudStore extends BaseUserApiRequest {
  Dio dio = Dio();

  MediaCloudStore(UserData userData) : super(userData);

  Future<bool> sendProjects(ProjectData projectData) async {
    List<MultipartFile> multiPartFiles = [];
    for (final page in projectData.pages) {
      multiPartFiles
          .add(await MultipartFile.fromFile(page.imagePath, filename: basename(page.imagePath)));
    }
    dio.options.headers['Authorization'] = 'Bearer ${userData.accessToken}';
    dio.options.headers['accept'] = 'application/json';
    var formData = FormData.fromMap({'files': multiPartFiles});
    var response = await dio.post(
        ['https:/', '5a4b-85-159-27-200.eu.ngrok.io', 'files', 'upload', projectData.code + '/']
            .join('/'),
        data: formData);
    if (response.statusCode != null) {
      return response.statusCode! >= 200 && response.statusCode! < 400;
    }
    return false;
  }
}
