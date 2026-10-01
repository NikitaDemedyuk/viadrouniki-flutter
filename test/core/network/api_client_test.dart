import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viadrouniki/core/error/app_exception.dart';
import 'package:viadrouniki/core/error/result.dart';
import 'package:viadrouniki/core/network/api_client.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  const notFound = '{"message":"Ресурс не найден","error_code":"not_found"}';

  String id(Object? json) => (json! as Map<String, dynamic>)['id'].toString();

  ApiClient clientWith(FakeHttpAdapter adapter, {String Function()? locale}) =>
      ApiClient(locale: locale ?? () => 'ru', adapter: adapter);

  AppException failureOf(Result<String> result) =>
      (result as Failure<String>).exception;

  group('ApiClient request', () {
    test('sends Accept: application/json', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');

      await clientWith(adapter).get('/trips', decode: id);

      expect(adapter.lastRequest.headers['Accept'], 'application/json');
    });

    test('resolves the path against the API base URL', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');

      await clientWith(adapter).get('/trips', decode: id);

      expect(
        adapter.lastRequest.uri.toString(),
        startsWith('https://api.viadrouniki.by/v1/trips'),
      );
    });

    test('adds the locale and keeps the caller query', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');

      await clientWith(adapter).get('/trips', query: {'page': 2}, decode: id);

      expect(adapter.lastRequest.uri.queryParameters, {
        'page': '2',
        'locale': 'ru',
      });
    });

    test('reads the locale again on every request', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');
      var locale = 'ru';
      final client = clientWith(adapter, locale: () => locale);

      await client.get('/trips', decode: id);
      locale = 'be';
      await client.get('/trips', decode: id);

      expect(adapter.requests.map((r) => r.uri.queryParameters['locale']), [
        'ru',
        'be',
      ]);
    });

    test('keeps a locale the caller set explicitly', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');

      await clientWith(adapter)
          .get('/trips', query: {'locale': 'be'}, decode: id);

      expect(adapter.lastRequest.uri.queryParameters['locale'], 'be');
    });
  });

  group('ApiClient result', () {
    test('decodes a 2xx body into Success', () async {
      final adapter = FakeHttpAdapter.json('{"id":7}');

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect((result as Success<String>).value, '7');
    });

    test('maps 401 to UnauthorizedException', () async {
      final adapter = FakeHttpAdapter.json(
        '{"message":"Unauthenticated."}',
        statusCode: 401,
      );

      final result = await clientWith(adapter).get('/auth/me', decode: id);

      expect(failureOf(result), isA<UnauthorizedException>());
    });

    test('maps an error body to ServerException with its message', () async {
      final adapter = FakeHttpAdapter.json(notFound, statusCode: 404);

      final result = await clientWith(adapter).get('/trips/x', decode: id);

      expect(
        failureOf(result),
        isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.message, 'message', 'Ресурс не найден')
            .having((e) => e.code, 'code', 'not_found'),
      );
    });

    test('maps a non-JSON 500 to ServerException without a message', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonBody(
          '<html>Server Error</html>',
          statusCode: 500,
          contentType: 'text/html',
        ),
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 500)
            .having((e) => e.message, 'message', isNull)
            .having((e) => e.code, 'code', isNull),
      );
    });

    test('ignores an error body whose fields are not strings', () async {
      final adapter = FakeHttpAdapter.json(
        '{"message":{"a":1},"error_code":5}',
        statusCode: 422,
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<ServerException>()
            .having((e) => e.message, 'message', isNull)
            .having((e) => e.code, 'code', isNull),
      );
    });

    test('maps a failed decode to DecodingException', () async {
      final adapter = FakeHttpAdapter.json('[1, 2]');

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(failureOf(result), isA<DecodingException>());
    });

    test('maps a malformed JSON body to DecodingException', () async {
      final adapter = FakeHttpAdapter.json('{"id":');

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(failureOf(result), isA<DecodingException>());
    });

    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      test('maps $type to NetworkException', () async {
        final adapter = FakeHttpAdapter(
          (options) => throw DioException(requestOptions: options, type: type),
        );

        final result = await clientWith(adapter).get('/trips', decode: id);

        expect(failureOf(result), isA<NetworkException>());
      });
    }

    test('maps a socket failure to NetworkException', () async {
      final adapter = FakeHttpAdapter(
        (options) => throw DioException(
          requestOptions: options,
          error: const SocketException('offline'),
        ),
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(failureOf(result), isA<NetworkException>());
    });

    test('maps a cancelled request to RequestCancelledException', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');
      final token = CancelToken()..cancel();

      final result = await clientWith(adapter)
          .get('/trips', decode: id, cancelToken: token);

      expect(failureOf(result), isA<RequestCancelledException>());
    });
  });
}
