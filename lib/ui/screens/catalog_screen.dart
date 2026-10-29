import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/book_item.dart';
import '../widgets/book_card.dart';

// == ВСТАВЬ СЮДА АДРЕС СВОЕГО ПРОЕКТА MOCKAPI ==
// Скопируй со страницы проекта (надпись «Конечная точка»), как есть:
const String baseUrl = 'https://6ae33b22933120ae20f87c58.mockapi.io/';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Набор ID лайкнутых книг (локально)
  final Set<int> _favoriteIds = {};

  // Флаг фильтра «Только избранные»
  bool _showOnlyFavorites = false;

  // Состояние загрузки каталога с сервера
  bool _isLoading = true;
  String? _error;
  List<BookItem> _books = [];

  // Форма добавления книги
  bool _showForm = false;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // GET: загрузка списка книг с сервера
  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl/books'));
      if (response.statusCode != 200) {
        throw Exception('Статус ${response.statusCode}');
      }
      final list = jsonDecode(response.body) as List;
      final books = list
          .map((e) => BookItem.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // POST: добавление новой книги на сервер
  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return; // пустое название не отправляем
    try {
      final draft = BookItem(
        title: title,
        author: '',
        year: '',
        genre: '',
        description: '',
      );
      final response = await http.post(
        Uri.parse('$baseUrl/books'),
        headers: {'Content-Type': 'application/json; charset=UTF8'},
        body: jsonEncode(draft.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Статус ${response.statusCode}');
      }
      final created = BookItem.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      setState(() {
        _books.insert(0, created); // новый элемент — в начало списка
        _showForm = false;
      });
      _titleController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось добавить книгу: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ошибка загрузки:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadBooks,
              icon: const Icon(Icons.refresh),
              label: const Text('Обновить'),
            ),
          ],
        ),
      );
    } else {
      // Фильтрация списка в зависимости от переключателя
      final displayedBooks = _showOnlyFavorites
          ? _books.where((book) => _favoriteIds.contains(book.id)).toList()
          : _books;

      body = Column(
        children: [
          if (_showForm) _buildAddForm(),
          Expanded(
            child: displayedBooks.isEmpty
                ? const Center(child: Text('Ничего не нашлось'))
                : ListView.builder(
                    itemCount: displayedBooks.length,
                    itemBuilder: (context, index) {
                      final book = displayedBooks[index];
                      final isFavorite = _favoriteIds.contains(book.id);

                      return BookCard(
                        book: book,
                        isFavorite: isFavorite,
                        onLikeTap: () {
                          setState(() {
                            final id = book.id;
                            if (id == null)
                              return; // у книги нет id — лайк не ставим
                            if (isFavorite) {
                              _favoriteIds.remove(id);
                            } else {
                              _favoriteIds.add(id);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
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
      body: body,
    );
  }

  // Форма добавления: TextField + кнопка «Отправить»
  Widget _buildAddForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название книги',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: _submit, child: const Text('Отправить')),
        ],
      ),
    );
  }
}
