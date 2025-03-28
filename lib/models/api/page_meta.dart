class PaginationMeta {
  PaginationMeta({
    required this.limit,
    required this.total,
    required this.offset,
    required this.hasNext,
  });

  final int limit;
  final int total;
  final int offset;
  final bool hasNext;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      limit: json['limit'] as int,
      total: json['total'] as int,
      offset: json['offset'] as int,
      hasNext: json['hasNext'],
    );
  }
}
