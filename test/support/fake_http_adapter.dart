import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef RequestHandler = FutureOr<ResponseBody> Function(RequestOptions);

class FakeHttpAdapter implements HttpClientAdapter {
  new(this.handler);

  factory json(String body, {int statusCode = 200}) =>
      FakeHttpAdapter((_) => jsonBody(body, statusCode: statusCode));

  final RequestHandler handler;
  final requests = <RequestOptions>[];

  RequestOptions get lastRequest => requests.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return await handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(
  String body, {
  int statusCode = 200,
  String contentType = Headers.jsonContentType,
}) => ResponseBody.fromBytes(
  utf8.encode(body),
  statusCode,
  headers: {
    Headers.contentTypeHeader: [contentType],
  },
);
