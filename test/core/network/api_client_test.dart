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

    test('maps a non-JSON 2xx to NetworkException without decoding', () async {
      final adapter = FakeHttpAdapter(
        (_) =>
            jsonBody('<html>Sign in to Wi-Fi</html>', contentType: 'text/html'),
      );
      var decoded = false;

      final result = await clientWith(adapter).get(
        '/trips',
        decode: (json) {
          decoded = true;
          return id(json);
        },
      );

      expect(failureOf(result), isA<NetworkException>());
      expect(decoded, isFalse);
    });

    test('maps a 2xx without a content type to NetworkException', () async {
      final adapter = FakeHttpAdapter(
        (_) => ResponseBody.fromString('{"id":1}', 200),
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(failureOf(result), isA<NetworkException>());
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

    test('keeps the status of an error body that is not valid JSON', () async {
      final adapter = FakeHttpAdapter.json(
        '<html>Bad Gateway</html>',
        statusCode: 502,
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 502)
            .having((e) => e.message, 'message', isNull),
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

    test('maps a failed decode to DecodingException with its cause', () async {
      final adapter = FakeHttpAdapter.json('[1, 2]');

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<DecodingException>()
            .having((e) => e.cause, 'cause', isA<TypeError>())
            .having((e) => e.stackTrace.toString(), 'stackTrace', isNotEmpty),
      );
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

    test('maps a socket failure to NetworkException with its cause', () async {
      const offline = SocketException('offline');
      final adapter = FakeHttpAdapter(
        (options) =>
            throw DioException(requestOptions: options, error: offline),
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<NetworkException>().having((e) => e.cause, 'cause', offline),
      );
    });

    test('maps a failed TLS handshake to NetworkException', () async {
      final adapter = FakeHttpAdapter(
        (_) => throw const HandshakeException('bad handshake'),
      );

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<NetworkException>().having(
          (e) => e.cause,
          'cause',
          isA<HandshakeException>(),
        ),
      );
    });

    test('maps an adapter bug to UnexpectedException', () async {
      final bug = StateError('adapter bug');
      final adapter = FakeHttpAdapter((_) => throw bug);

      final result = await clientWith(adapter).get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<UnexpectedException>()
            .having((e) => e.cause, 'cause', bug)
            .having((e) => e.stackTrace, 'stackTrace', same(bug.stackTrace)),
      );
    });

    test('maps an interceptor bug to UnexpectedException', () async {
      final adapter = FakeHttpAdapter.json('{"id":1}');
      final client = clientWith(
        adapter,
        locale: () => throw StateError('no locale'),
      );

      final result = await client.get('/trips', decode: id);

      expect(
        failureOf(result),
        isA<UnexpectedException>().having(
          (e) => e.cause,
          'cause',
          isA<StateError>(),
        ),
      );
      expect(adapter.requests, isEmpty);
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
