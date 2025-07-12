class SearchFilter {
  final String type;
  final String sort;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String status;
  final List<String> selectedTags;

  SearchFilter({
    this.type = 'Tous',
    this.sort = 'Plus récent',
    this.dateFrom,
    this.dateTo,
    this.status = 'Tous',
    this.selectedTags = const [],
  });

  SearchFilter copyWith({
    String? type,
    String? sort,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? status,
    List<String>? selectedTags,
  }) {
    return SearchFilter(
      type: type ?? this.type,
      sort: sort ?? this.sort,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      status: status ?? this.status,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }
}
