class LegalDocument {
  final String id;
  final String title;
  final String type;
  final String description;
  final DateTime date;
  final String status;
  final List<String> tags;
  final String content;
  final bool isFavorite;
  final int views;

  LegalDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
    required this.tags,
    required this.content,
    this.isFavorite = false,
    this.views = 0,
  });
}
