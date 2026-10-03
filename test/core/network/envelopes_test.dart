import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:viadrouniki/core/network/envelopes.dart';

void main() {
  Object? fixture(String name) =>
      jsonDecode(File('test/fixtures/$name.json').readAsStringSync());

  int id(JsonMap json) => json['id']! as int;

  group('decodePaginated', () {
    test('reads the items and the pagination meta', () {
      final page = decodePaginated(fixture('trips_page'), id);

      expect(page.items, hasLength(2));
      expect(page.meta.currentPage, 1);
      expect(page.meta.perPage, 2);
      expect(page.meta.total, greaterThan(page.items.length));
      expect(page.meta.hasNextPage, isTrue);
    });

    test('reports no next page on the last page', () {
      final page = decodePaginated({
        'data': <Object?>[],
        'meta': {
          'current_page': 3,
          'last_page': 3,
          'per_page': 15,
          'total': 40,
        },
      }, id);

      expect(page.meta.hasNextPage, isFalse);
    });

    test('rejects a body without meta', () {
      expect(
        () => decodePaginated({'data': <Object?>[]}, id),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('decodeSingle', () {
    test('unwraps data', () {
      expect(decodeSingle(fixture('trip'), id), 5);
    });

    test('rejects a bare object', () {
      expect(() => decodeSingle({'id': 5}, id), throwsA(isA<TypeError>()));
    });
  });

  group('decodeDataList', () {
    test('unwraps a list under data', () {
      expect(decodeDataList(fixture('trip_cars'), id), [38, 63, 68]);
    });
  });

  group('decodeBareList', () {
    test('reads a top-level array', () {
      expect(decodeBareList(fixture('attractions_map'), id), hasLength(3));
    });

    test('rejects an object with data', () {
      expect(
        () => decodeBareList({'data': <Object?>[]}, id),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
