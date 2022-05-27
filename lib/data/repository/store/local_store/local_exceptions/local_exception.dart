enum LocalExceptionCode {
  notFound,
  boxNotInitialized,
  dataTooLarge,
  closed,
  alreadyExists,
  noAccess
}

class LocalException implements Exception {
  LocalExceptionCode code;
  late String message;

  LocalException({required this.code, String? msg}) {
    switch (code) {
      case LocalExceptionCode.boxNotInitialized:
        message = 'Local storage not initialized';
        break;
      case LocalExceptionCode.notFound:
        message = 'Not found';
        break;
      case LocalExceptionCode.dataTooLarge:
        message = 'Request too large';
        break;
      case LocalExceptionCode.closed:
        message = 'Local storage closed';
        break;
      case LocalExceptionCode.noAccess:
        message = 'Do not have permission';
        break;
      case LocalExceptionCode.alreadyExists:
        message = 'Already exists';
        break;
    }
  }

  @override
  String toString() {
    return 'LocalException{message: $message}';
  }
}
