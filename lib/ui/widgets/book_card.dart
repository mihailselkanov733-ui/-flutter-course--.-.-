import 'package:flutter/material.dart';

import '../../domain/entities/book_item.dart';
import 'book_cover.dart';

// Карточка книги: обложка с Hero-анимацией, название, подпись,
// иконка категории и кнопка лайка; тап открывает экран деталей
class BookCard extends StatelessWidget {
  final BookItem book;
  final bool isFavorite;
  final VoidCallback onLikeTap;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onLikeTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Hero — обложка «перелетает» на экран деталей (опция «Анимации»)
              Hero(
                tag: 'book-cover-${book.id}',
                child: BookCover(title: book.title),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconForGenre(book.genre),
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.genre.isEmpty ? 'Без жанра' : book.genre,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite ? 'Убрать из избранного' : 'В избранное',
                onPressed: onLikeTap,
                icon: AnimatedScale(
                  // Анимация нажатия на лайк: сердечко «пружинит»
                  scale: isFavorite ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Подпись карточки: «автор · год», пустые части заменяем заглушками
  String _subtitle() {
    final parts = [
      book.author.isEmpty ? 'Без автора' : book.author,
      book.year.isEmpty ? '' : book.year,
    ].where((part) => part.isNotEmpty).toList();
    return parts.isEmpty ? '' : parts.join(' · ');
  }
}
