enum RequestExceptionCode {
  badRequest,
  notFound,
  communication,
  internal,
  timeOut,
  serviceUnavailable,
  forbidden,
  payloadTooLarge,
  canceled
}

class RequestException implements Exception {
  RequestExceptionCode code;
  late String message;

  RequestException({required this.code, String? msg}) {
    switch (code) {
      case RequestExceptionCode.communication:
        message = 'Internet exception';
        break;
      case RequestExceptionCode.internal:
        message = 'Internal error';
        break;
      case RequestExceptionCode.timeOut:
        message = 'Time out';
        break;
      case RequestExceptionCode.serviceUnavailable:
        message = 'Service Unavailable';
        break;
      case RequestExceptionCode.forbidden:
        message = msg ?? 'Forbidden';
        break;
      case RequestExceptionCode.badRequest:
        message = msg ?? 'Bad Request';
        break;
      case RequestExceptionCode.notFound:
        message = 'Not found';
        break;
      case RequestExceptionCode.payloadTooLarge:
        message = 'Request too large';
        break;
      case RequestExceptionCode.canceled:
        message = 'Request is canceled';
        break;
    }
  }

  @override
  String toString() {
    return 'RequestException{message: $message}';
  }
}
