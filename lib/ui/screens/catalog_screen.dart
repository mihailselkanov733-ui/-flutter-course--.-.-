import 'package:flutter/material.dart';

import '../../domain/entities/book_item.dart';
import '../widgets/book_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Набор ID выбранных элементов (избранное)
  final Set<int> _favoriteIds = {};

  // Флаг фильтра «Только избранные»
  bool _showOnlyFavorites = false;

  // Список из 8 и более элементов каталога (константа)
  static const List<BookItem> _books = [
    BookItem(
      id: 1,
      title: 'Дом на болоте',
      author: 'Алексей Калугин',
      year: '2007',
      genre: 'Фантастика',
    ),
    BookItem(
      id: 2,
      title: 'Метро 2033',
      author: 'Дмитрий Глуховский',
      year: '2005',
      genre: 'Постапокалипсис',
    ),
    BookItem(
      id: 3,
      title: 'Пикник на обочине',
      author: 'Аркадий и Борис Стругацкие',
      year: '1972',
      genre: 'Фантастика',
    ),
    BookItem(
      id: 4,
      title: 'Сердце Зоны',
      author: 'Олег Дивов',
      year: '2008',
      genre: 'Фантастика',
    ),
    BookItem(
      id: 5,
      title: 'Линия огня',
      author: 'Алексей Калугин',
      year: '2006',
      genre: 'Фантастика',
    ),
    BookItem(
      id: 6,
      title: 'Эпоха мертвых',
      author: 'Андрей Круз',
      year: '2008',
      genre: 'Зомби-апокалипсис',
    ),
    BookItem(
      id: 7,
      title: 'Чистое небо',
      author: 'Виктор Носков',
      year: '2010',
      genre: 'Фантастика',
    ),
    BookItem(
      id: 8,
      title: 'Обратный отсчет',
      author: 'Василий Орехов',
      year: '2007',
      genre: 'Фантастика',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Фильтрация списка в зависимости от переключателя
    final displayedBooks = _showOnlyFavorites
        ? _books.where((book) => _favoriteIds.contains(book.id)).toList()
        : _books;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        actions: [
          Row(
            children: [
              const Text('Избранное', style: TextStyle(fontSize: 14)),
              Switch(
                value: _showOnlyFavorites,
                onChanged: (value) {
                  setState(() {
                    _showOnlyFavorites = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: displayedBooks.length,
        itemBuilder: (context, index) {
          final book = displayedBooks[index];
          final isFavorite = _favoriteIds.contains(book.id);

          return BookCard(
            book: book,
            isFavorite: isFavorite,
            onLikeTap: () {
              setState(() {
                if (isFavorite) {
                  _favoriteIds.remove(book.id);
                } else {
                  _favoriteIds.add(book.id);
                }
              });
            },
          );
        },
      ),
    );
  }
}
