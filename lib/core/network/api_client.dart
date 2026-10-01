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
          // Without it, a protected route answers 500 text/html, not 401 json.
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
    final Response<Object?> response;
    try {
      response = await _dio.get<Object?>(
        path,
        queryParameters: query,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      return Failure(_mapError(error));
    }
    try {
      return Success(decode(response.data));
    } on Object catch (error) {
      return Failure(DecodingException(error));
    }
  }

  AppException _mapError(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError => const NetworkException(),
    DioExceptionType.cancel => const RequestCancelledException(),
    DioExceptionType.badCertificate => const NetworkException(),
    DioExceptionType.badResponse => _mapBadResponse(error.response!),
    DioExceptionType.unknown => switch (error.error) {
      final FormatException format => DecodingException(format),
      _ => const NetworkException(),
    },
  };

  AppException _mapBadResponse(Response<Object?> response) {
    final statusCode = response.statusCode!;
    if (statusCode == 401) return const UnauthorizedException();
    final body = response.data;
    return ServerException(
      statusCode: statusCode,
      message: body is Map<String, Object?> && body['message'] is String
          ? body['message']! as String
          : null,
      code: body is Map<String, Object?> && body['error_code'] is String
          ? body['error_code']! as String
          : null,
    );
  }
}
