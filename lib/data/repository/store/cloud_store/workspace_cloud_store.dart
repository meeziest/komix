import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_exception.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class UploadDownloadInfo {
  final double mbitPerS;
  final double mbPerS;
  final double percent;
  final int secondsLeft;
  final Completer? _completerForCanceling;

  int get percentString => (percent * 100).toInt();

  UploadDownloadInfo(
      {required this.mbitPerS,
      required this.mbPerS,
      required this.percent,
      required this.secondsLeft,
      Completer? completerForCanceling})
      : _completerForCanceling = completerForCanceling;

  void cancelDownloading() {
    _completerForCanceling?.complete();
  }

  bool isCompleted() {
    if (_completerForCanceling != null) {
      return _completerForCanceling!.isCompleted;
    }
    return false;
  }

  @override
  String toString() {
    return 'mbitPerS: ${mbitPerS.toStringAsFixed(3)}\nseconds left: $secondsLeft\npercent: $percentString%';
  }
}

typedef OnDownloadProgressCallback = void Function(UploadDownloadInfo info);
typedef OnUploadProgressCallback = void Function(UploadDownloadInfo info);

class WorkSpaceMediaCloudStore {
  final UserData userData;

  WorkSpaceMediaCloudStore(this.userData);

  Future<String> fileUpload(File file, {OnUploadProgressCallback? onUploadProgress}) async {
    final String mimeType = lookupMimeType(file.path) ?? '';
    final filename = p.basename(file.path);

    Completer completerForCanceling = Completer();

    final requestUri = Uri.parse('https://${userData.baseUrl}/media/r0/upload?filename=$filename');

    final fileStream = file.openRead();

    int totalByteLength = file.lengthSync();

    final httpClient = _getHttpClient();

    final request = await httpClient.postUrl(requestUri);

    request.headers.set('content-type', 'application/octet-stream');
    request.headers.add('authorization', 'Bearer ${userData.accessToken}');
    request.headers.add('content-type', mimeType);

    request.contentLength = totalByteLength;

    int byteCount = 0;
    DateTime timestamp = DateTime.now();

    Stream<List<int>> streamUpload = fileStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final int currentUploadedSize = byteCount + data.length;
          byteCount = currentUploadedSize;
          sink.add(data);
        },
        handleError: (error, stack, sink) {
          debugPrint(error.toString());
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    final timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      final DateTime now = DateTime.now();

      final double secondsSpent = now.difference(timestamp).inMilliseconds / 1000;

      final mbit = byteCount / 131072;
      final mb = mbit * 0.125;

      final mbitPerS = mbit / secondsSpent;
      final mbPerS = mb / secondsSpent;
      final leftUploadMb = (totalByteLength / 1048576) - mb;
      final secondsLeft = leftUploadMb / mbPerS;

      final uploadInfo = UploadDownloadInfo(
          percent: byteCount / totalByteLength,
          mbitPerS: mbitPerS,
          secondsLeft: secondsLeft.toInt(),
          completerForCanceling: completerForCanceling,
          mbPerS: mbPerS);
      debugPrint(uploadInfo.toString());
      if (onUploadProgress != null) {
        onUploadProgress(uploadInfo);
        // CALL STATUS CALLBACK;
      }
    });

    completerForCanceling.future.then((value) {
      request.abort();
      timer.cancel();
    });

    await request.addStream(streamUpload);

    final httpResponse = await request.close();
    timer.cancel();
    if (httpResponse.statusCode != 200) {
      final String body = await _readResponseAsString(httpResponse);
      throw RequestException(code: RequestExceptionCode.internal, msg: body);
    } else {
      final String body = await _readResponseAsString(httpResponse);
      final json = jsonDecode(body);
      return json['content_uri'];
    }
  }

  Future<String> fileDownload(String key, {OnDownloadProgressCallback? onDownloadProgress}) async {
    final url =
        Uri.parse('https://${userData.baseUrl}/media/r0/download/${key.replaceAll('mxc://', '')}');
    debugPrint('download file: $url');
    final httpClient = _getHttpClient();
    final request = await httpClient.getUrl(url);
    request.headers.add('content-type', 'application/octet-stream');
    var httpResponse = await request.close();

    Directory appDocDir = await getTemporaryDirectory();
    String appDocPath = appDocDir.path;
    String filename = key.replaceAll('/', '').replaceAll(':', '').replaceAll('@', '');
    File file = File(appDocPath + '/' + filename);
    debugPrint('temp file path: ${file.path}');
    var raf = file.openSync(mode: FileMode.write);
    Completer completer = Completer<String>();
    Completer completerForCancel = Completer();

    DateTime timestamp = DateTime.now();
    int byteCount = 0;
    int totalByteLength = httpResponse.contentLength;

    var streamListener = httpResponse.listen(
      (data) {
        byteCount += data.length;
        raf.writeFromSync(data);
      },
      onDone: () {
        raf.closeSync();
        completer.complete(file.path);
      },
      onError: (e) {
        raf.closeSync();
        file.deleteSync();
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    final timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      final DateTime now = DateTime.now();

      final double secondsSpent = now.difference(timestamp).inMilliseconds / 1000;

      final mbit = byteCount / 131072;
      final mb = mbit * 0.125;

      final mbitPerS = mbit / secondsSpent;
      final mbPerS = mb / secondsSpent;
      final leftUploadMb = (totalByteLength / 1048576) - mb;
      final secondsLeft = leftUploadMb / mbPerS;

      final uploadInfo = UploadDownloadInfo(
        percent: byteCount / totalByteLength,
        mbitPerS: mbitPerS,
        secondsLeft: secondsLeft.toInt(),
        completerForCanceling: completerForCancel,
        mbPerS: mbPerS,
      );
      debugPrint(uploadInfo.toString());
      if (onDownloadProgress != null) {
        onDownloadProgress(uploadInfo);
        // CALL STATUS CALLBACK;
      }
    });

    completerForCancel.future.then((value) {
      request.abort();
      streamListener.cancel();
      raf.closeSync();
      file.deleteSync();
      completer.completeError(RequestException(code: RequestExceptionCode.canceled));
      timer.cancel();
    });

    String filePath = await completer.future;

    timer.cancel();
    return filePath;
  }

  static HttpClient _getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
    return httpClient;
  }

  static bool trustSelfSigned = true;

  static Future<String> _readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
