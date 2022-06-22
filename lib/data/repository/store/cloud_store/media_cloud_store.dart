import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_user_api_request.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/utl_const.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class MediaCloudStore extends BaseUserApiRequest {
  Dio dio = Dio();

  MediaCloudStore(UserData userData) : super(userData);

  Future<bool> sendProjects(String projectCode, List<File> pages) async {
    List<MultipartFile> multiPartFiles = [];
    for (final page in pages) {
      multiPartFiles.add(await MultipartFile.fromFile(page.path, filename: basename(page.path)));
    }
    dio.options.headers['Authorization'] = 'Bearer ${userData.accessToken}';
    dio.options.headers['accept'] = 'application/json';
    var formData = FormData.fromMap({'files': multiPartFiles});
    var response = await dio.post(
        ['https:/', ServerUrlData.baseUrl(), 'files', 'upload', projectCode + '/'].join('/'),
        data: formData);
    if (response.statusCode != null) {
      return response.statusCode! >= 200 && response.statusCode! < 400;
    }
    return false;
  }

  Future<void> downloadFile(String fileUrl, String savePath) async {
    try {
      await dio.download(fileUrl, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
