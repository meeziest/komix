import 'dart:convert';

import 'package:http/http.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/request_interface.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_exception.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_type.dart';

const String className = 'BaseApiRequest';

class BaseApiRequest implements ApiRequest {
  BaseApiRequest();

  @override
  Future<Response> makeRequest({
    required String path,
    required RequestType requestType,
    String? body,
    Map<String, dynamic>? data,
    Map<String, String>? queryParameters,
    Map<String, String>? extraHeaders,
    int timeout = 15,
    bool userAuth = true,
  }) async {
    Map<String, String> headers = extraHeaders ?? {};
    Uri uri = Uri.https('5a4b-85-159-27-200.eu.ngrok.io', path, queryParameters);
    Response? response;
    try {
      switch (requestType) {
        case RequestType.post:
          response = await post(uri, body: jsonEncode(data), headers: headers);
          break;
        case RequestType.get:
          response = await get(uri, headers: headers)
              .timeout(Duration(seconds: timeout), onTimeout: onTimeout);
          break;
        case RequestType.put:
          response = await put(uri, body: jsonEncode(data), headers: headers)
              .timeout(Duration(seconds: timeout), onTimeout: onTimeout);
          break;
      }
    } catch (e) {
      throw RequestException(code: RequestExceptionCode.communication);
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> decoded = json.decode(response.body);
        generalResponseProcessing(decoded);
      }
      return response;
    } else {
      switch (response.statusCode) {
        case 503:
          throw RequestException(code: RequestExceptionCode.serviceUnavailable);
        case 403:
          throw RequestException(code: RequestExceptionCode.forbidden, msg: response.body);
      }
      throw RequestException(code: RequestExceptionCode.internal);
    }
  }

  @override
  Future<Response> onTimeout() async {
    throw RequestException(code: RequestExceptionCode.timeOut);
  }

  @override
  void generalResponseProcessing(Map<String, dynamic> body) async {}
}
