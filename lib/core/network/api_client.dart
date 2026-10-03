import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:viadrouniki/core/error/app_exception.dart';
import 'package:viadrouniki/core/error/result.dart';
import 'package:viadrouniki/core/network/api_config.dart';

class ApiClient {
  new({required String Function() locale, HttpClientAdapter? adapter})
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.connectTimeout,
          receiveTimeout: ApiConfig.receiveTimeout,
          headers: {Headers.acceptHeader: Headers.jsonContentType},
        ),
      ) {
    if (adapter != null) _dio.httpClientAdapter = adapter;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters.putIfAbsent('locale', locale);
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;

  Future<Result<T>> get<T>(
    String path, {
    required T Function(Object? json) decode,
    Map<String, Object?>? query,
    CancelToken? cancelToken,
  }) async {
    final Response<String> response;
    try {
      // Dio parses JSON before it checks the status, and a parse failure
      // there drops the response along with its status.
      response = await _dio.get<String>(
        path,
        queryParameters: query,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      return Failure(_mapError(error));
    }
    final contentType = response.headers.value(Headers.contentTypeHeader);
    if (!Transformer.isJsonMimeType(contentType)) {
      return Failure(
        NetworkException(FormatException('Not a JSON response', contentType)),
      );
    }
    try {
      return Success(decode(jsonDecode(response.data ?? '')));
    } on Object catch (error, stackTrace) {
      return Failure(DecodingException(error, stackTrace));
    }
  }

  AppException _mapError(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError ||
    DioExceptionType.badCertificate => NetworkException(error.error),
    DioExceptionType.cancel => const RequestCancelledException(),
    DioExceptionType.badResponse => _mapBadResponse(error.response!),
    // Dio reports failed connects as connectionError, so what lands here is
    // either an I/O failure mid-response or a bug in the request pipeline.
    DioExceptionType.unknown => switch (error.error) {
      final IOException io => NetworkException(io),
      final cause? => UnexpectedException(
        cause,
        // Dio wraps an adapter's error with the request's call site, not the
        // throw site; an Error records its own.
        (cause is Error ? cause.stackTrace : null) ?? error.stackTrace,
      ),
      null => UnexpectedException(error, error.stackTrace),
    },
  };

  AppException _mapBadResponse(Response<Object?> response) {
    final statusCode = response.statusCode!;
    if (statusCode == 401) return const UnauthorizedException();
    final body = _tryJson(response.data);
    return ServerException(
      statusCode: statusCode,
      message: switch (body) {
        {'message': final String message} => message,
        _ => null,
      },
      code: switch (body) {
        {'error_code': final String code} => code,
        _ => null,
      },
    );
  }

  Object? _tryJson(Object? data) {
    if (data is! String) return null;
    try {
      return jsonDecode(data);
    } on FormatException {
      return null;
    }
  }
}
