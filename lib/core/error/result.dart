import 'package:viadrouniki/core/error/app_exception.dart';

sealed class Result<T> {
  const new();
}

final class Success<T> extends Result<T> {
  const new(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const new(this.exception);

  final AppException exception;
}
