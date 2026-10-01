class PaginationMeta {
  const new({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory fromJson(Map<String, dynamic> json) => PaginationMeta(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    perPage: json['per_page'] as int,
    total: json['total'] as int,
  );

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasNextPage => currentPage < lastPage;
}

class Paginated<T> {
  const new({required this.items, required this.meta});

  final List<T> items;
  final PaginationMeta meta;
}
