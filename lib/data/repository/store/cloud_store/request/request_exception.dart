enum RequestExceptionCode {
  badRequest,
  notFound,
  communication,
  internal,
  timeOut,
  serviceUnavailable,
  forbidden,
  payloadTooLarge,
  incorrectCredentials,
  canceled
}

class RequestException implements Exception {
  RequestExceptionCode code;
  late String message;

  RequestException({required this.code, String? msg}) {
    switch (code) {
      case RequestExceptionCode.communication:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Internet exception';
        }
        break;
      case RequestExceptionCode.internal:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Internal error';
        }
        break;
      case RequestExceptionCode.timeOut:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Time out';
        }
        break;
      case RequestExceptionCode.serviceUnavailable:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Service Unavailable';
        }
        break;
      case RequestExceptionCode.forbidden:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = msg ?? 'Forbidden';
        }
        break;
      case RequestExceptionCode.badRequest:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = msg ?? 'Bad Request';
        }
        break;
      case RequestExceptionCode.notFound:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Not found';
        }
        break;
      case RequestExceptionCode.payloadTooLarge:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Request too large';
        }
        break;
      case RequestExceptionCode.canceled:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Request is canceled';
        }
        break;
      case RequestExceptionCode.incorrectCredentials:
        if (msg != null && msg.isNotEmpty) {
          message = msg;
        } else {
          message = 'Incorrect credentials';
        }
        break;
    }
  }

  @override
  String toString() {
    return 'RequestException{message: $message}';
  }
}
