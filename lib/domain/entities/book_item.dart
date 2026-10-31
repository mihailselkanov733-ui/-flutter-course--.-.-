import 'package:cloud_firestore/cloud_firestore.dart';

class BookItem {
  final String? id; // id документа Firestore (doc.id) — строка
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

  // Превращение документа Firestore в модель (id берём из doc.id)
  factory BookItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return BookItem(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      author: (data['author'] ?? '').toString(),
      year: (data['year'] ?? '').toString(),
      genre: (data['genre'] ?? '').toString(),
      description: data['description'] as String?,
    );
  }

  // Превращение модели в Map для add() — id не отправляем, Firestore его выдаст
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
