import 'package:flutter/material.dart';

import '../../domain/entities/book_item.dart'; // Путь к вашей модели

class BookCard extends StatelessWidget {
  final BookItem book;
  final bool isFavorite;
  final VoidCallback onLikeTap;

  const BookCard({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${book.author} (${book.year})'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onLikeTap,
        ),
      ),
    );
  }
}
