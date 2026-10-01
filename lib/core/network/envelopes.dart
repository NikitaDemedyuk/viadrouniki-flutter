import 'package:viadrouniki/core/network/pagination.dart';

typedef JsonMap = Map<String, dynamic>;

Paginated<T> decodePaginated<T>(
  Object? json,
  T Function(JsonMap json) decodeItem,
) {
  final body = json! as JsonMap;
  return Paginated(
    items: _decodeList(body['data'], decodeItem),
    meta: PaginationMeta.fromJson(body['meta']! as JsonMap),
  );
}

T decodeSingle<T>(Object? json, T Function(JsonMap json) decodeItem) =>
    decodeItem((json! as JsonMap)['data']! as JsonMap);

List<T> decodeDataList<T>(Object? json, T Function(JsonMap json) decodeItem) =>
    _decodeList((json! as JsonMap)['data'], decodeItem);

List<T> decodeBareList<T>(Object? json, T Function(JsonMap json) decodeItem) =>
    _decodeList(json, decodeItem);

List<T> _decodeList<T>(Object? json, T Function(JsonMap json) decodeItem) =>
    (json! as List<Object?>)
        .map((item) => decodeItem(item! as JsonMap))
        .toList();
