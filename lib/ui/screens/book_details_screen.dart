import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/books_bloc.dart';
import '../../bloc/books_event.dart';
import '../../bloc/books_state.dart';
import '../../domain/entities/book_item.dart';
import '../widgets/book_cover.dart';

// Экран деталей книги: открывается по тапу на карточку каталога.
// Лайк берётся из того же BooksBloc, поэтому совпадает со списком
class BookDetailsScreen extends StatelessWidget {
  final BookItem book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          final isFavorite =
              state is BooksLoadSuccess && state.favoriteIds.contains(book.id);
          return FloatingActionButton.extended(
            tooltip: 'Лайк сохраняется в Firestore',
            icon: AnimatedScale(
              // Такая же анимация «пружинки», как в карточке списка
              scale: isFavorite ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            ),
            label: Text(isFavorite ? 'В избранном' : 'В избранное'),
            onPressed: () {
              final id = book.id;
              if (id == null) return; // у книги нет id — лайк не ставим
              context.read<BooksBloc>().add(BooksFavoriteToggled(id));
            },
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'book-cover-${book.id}',
                child: BookCover(title: book.title, size: 144, fontSize: 56),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  iconForGenre(book.genre),
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  book.genre.isEmpty ? 'Без жанра' : book.genre,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              book.author.isEmpty ? 'Автор не указан' : 'Автор: ${book.author}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              book.year.isEmpty ? 'Год не указан' : 'Год: ${book.year}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              'Описание',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              (book.description == null || book.description!.isEmpty)
                  ? 'Описание пока не заполнено.'
                  : book.description!,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
