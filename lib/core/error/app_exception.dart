sealed class AppException implements Exception {
  const new();
}

class NetworkException extends AppException {
  const new();
}

class RequestCancelledException extends AppException {
  const new();
}

class UnauthorizedException extends AppException {
  const new();
}

class ServerException extends AppException {
  const new({required this.statusCode, this.message, this.code});

  final int statusCode;
  final String? message;
  final String? code;

  @override
  String toString() => 'ServerException($statusCode, $code: $message)';
}

class DecodingException extends AppException {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'DecodingException($cause)';
}
