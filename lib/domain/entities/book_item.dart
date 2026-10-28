class BookItem {
  final int id;
  final String title;
  final String author;
  final String year;
  final String genre;
  final String? description; // необязательное поле

  const BookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    this.description,
  });
}
