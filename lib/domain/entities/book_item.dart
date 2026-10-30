class BookItem {
  final int? id; // nullable: id выдаёт сервер, при создании его не отправляем
  final String title;
  final String author;
  final String year;
  final String genre;
  final String? description; // необязательное поле

  const BookItem({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    this.description,
  });

  // Превращение JSON с сервера в модель
  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: (json['title'] ?? '').toString(),
      author: (json['author'] ?? '').toString(),
      year: (json['year'] ?? '').toString(),
      genre: (json['genre'] ?? '').toString(),
      description: json['description'] as String?,
    );
  }

  // Превращение модели в Map для POST-запроса (без id!)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'genre': genre,
      'description': description ?? '',
    };
  }
}
