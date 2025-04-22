class PaginationMeta {
  PaginationMeta({this.limit, this.total, this.offset, this.hasNext});

  final int? limit;
  final int? total;
  final int? offset;
  final bool? hasNext;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      limit: json['limit'],
      total: json['total'],
      offset: json['offset'],
      hasNext: json['hasNext'],
    );
  }
}
