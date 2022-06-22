import 'package:http/http.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_exception.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_type.dart';

abstract class ApiRequest {
  Future<Response> makeRequest({
    required String path,
    required RequestType requestType,
    String? body,
    Map<String, dynamic>? data,
    Map<String, String>? queryParameters,
    Map<String, String>? extraHeaders,
    int timeout = 15,
    bool userAuth = false,
  });

  Future<Response> onTimeout() async {
    throw RequestException(code: RequestExceptionCode.timeOut);
  }

  String? responseMessageProcessing(Response response) {
    throw UnimplementedError();
  }

  void generalResponseProcessing(Map<String, dynamic> body) async {}
}
