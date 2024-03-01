class ServerException implements Exception {}

class DataParsingException implements Exception {}

class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'Unauthorized request', url);
}

class CacheException extends AppException {
  CacheException([String? message, String? url])
      : super(message, 'Cache Error', url);
}

class NoConnectionException implements Exception {
  final bool status;
  final String message;

  NoConnectionException(this.status, this.message);

  @override
  String toString() =>
      'NoConnectionException{status=$status, message=$message}';
}
