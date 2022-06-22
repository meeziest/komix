import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/request_interface.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/base/utl_const.dart';
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
    Uri uri = Uri.https(ServerUrlData.baseUrl(), path, queryParameters);
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
      if (e is SocketException) {
        final codeUnits = e.osError?.message.codeUnits;
        String eMessage = const Utf8Decoder().convert(codeUnits!);
        eMessage = eMessage.trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");
        throw RequestException(code: RequestExceptionCode.communication, msg: eMessage);
      }
      throw RequestException(code: RequestExceptionCode.communication);
    }
    String? message = responseMessageProcessing(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        final codeUnits = response.body.codeUnits;
        String body = const Utf8Decoder().convert(codeUnits);
        Map<String, dynamic> decoded = json.decode(body);
        generalResponseProcessing(decoded);
        return response;
      }
      return response;
    } else {
      switch (response.statusCode) {
        case 503:
          throw RequestException(code: RequestExceptionCode.serviceUnavailable, msg: message);
        case 403:
          throw RequestException(code: RequestExceptionCode.forbidden, msg: message);
        case 400:
          print(response.body);
          throw RequestException(code: RequestExceptionCode.incorrectCredentials, msg: message);
      }
      throw RequestException(code: RequestExceptionCode.internal);
    }
  }

  @override
  String? responseMessageProcessing(Response response) {
    final codeUnits = response.body.codeUnits;
    String body = const Utf8Decoder().convert(codeUnits);
    String? message;
    try {
      Map<String, dynamic> decoded = json.decode(body);
      if (decoded.containsKey('message')) {
        message = decoded['message'];
      }
    } catch (e) {
      //skip
    }
    return message;
  }

  @override
  Future<Response> onTimeout() async {
    throw RequestException(code: RequestExceptionCode.timeOut);
  }

  @override
  void generalResponseProcessing(Map<String, dynamic> body) async {}
}
