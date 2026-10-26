import 'package:flutter/material.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Каталог книг S.T.A.L.K.E.R.',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const CatalogScreen(),
    );
  }
}

// Модель данных для книги
class BookItem {
  final String title;
  final String author;
  final String year;
  final String genre;
  final Color coverColor;

  const BookItem({
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    required this.coverColor,
  });
}

// Список книг вынесен за пределы класса (теперь нет ошибок с const)
final List<BookItem> stalkerBooks = [
  const BookItem(
    title: 'Дом на болоте',
    author: 'Алексей Калугин',
    year: '2007',
    genre: 'Фантастика',
    coverColor: Color(0xFF388E3C),
  ),
  const BookItem(
    title: 'Чистое Небо',
    author: 'Аркадий Швайгер',
    year: '2008',
    genre: 'Боевик',
    coverColor: Color(0xFF0288D1),
  ),
  const BookItem(
    title: 'Мечта на поражение',
    author: 'Андрей Левицкий',
    year: '2007',
    genre: 'Приключения',
    coverColor: Color(0xFFE64A19),
  ),
  const BookItem(
    title: 'Дезертир',
    author: 'Алексей Степанов',
    year: '2007',
    genre: 'Военная фантастика',
    coverColor: Color(0xFF5D4037),
  ),
  const BookItem(
    title: 'Линия огня',
    author: 'Олег Дивов',
    year: '2007',
    genre: 'Боевик',
    coverColor: Color(0xFFC2185B),
  ),
  const BookItem(
    title: 'Выбор оружия',
    author: 'Андрей Левицкий',
    year: '2007',
    genre: 'Фантастика',
    coverColor: Color(0xFF7B1FA2),
  ),
  const BookItem(
    title: 'Зоны особого внимания',
    author: 'Вячеслав Шалыгин',
    year: '2008',
    genre: 'Экшен',
    coverColor: Color(0xFF00796B),
  ),
  const BookItem(
    title: 'Обратный отсчет',
    author: 'Вячеслав Шалыгин',
    year: '2007',
    genre: 'Научная фантастика',
    coverColor: Color(0xFFF57C00),
  ),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог: S.T.A.L.K.E.R.'),
        backgroundColor: const Color(0xFF2C2C2C),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: stalkerBooks.length,
        itemBuilder: (context, index) {
          final book = stalkerBooks[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12.0),
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Обложка (Stack из трёх слоев)
                  SizedBox(
                    width: 70,
                    height: 90,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: book.coverColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        Center(
                          child: Text(
                            book.title[0],
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Текст с Expanded и защитой от переполнения
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Автор: ${book.author} (${book.year})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            book.genre,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
