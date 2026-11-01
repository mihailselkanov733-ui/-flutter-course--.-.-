import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/books_bloc.dart';
import '../../bloc/books_event.dart';
import '../../bloc/books_state.dart';
import '../../domain/entities/book_item.dart';
import '../widgets/book_card.dart';

// Коллекция каталога в Firestore: тема латиницей во множественном числе
const String collectionName = 'books';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Локальные лайки и фильтр «Только избранные» (как в ДЗ 4, но id теперь строки)
  final Set<String> _favoriteIds = {};
  bool _showOnlyFavorites = false;

  // Форма добавления
  bool _showForm = false;
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Добавление книги: сохраняем в Firestore через add — элемент появится сам
  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return; // пустое название не отправляем
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .add(
            BookItem(title: title, author: '', year: '', genre: '').toJson(),
          );
      setState(() {
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

  // Выход: authStateChanges сам вернёт нас на экран входа
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

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

  @override
  Widget build(BuildContext context) {
    Widget body = BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        // Пока идёт загрузка — индикатор
        if (state is BooksLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        // Ошибка — понятный текст и кнопка «Обновить»
        if (state is BooksLoadFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      context.read<BooksBloc>().add(BooksLoadRequested()),
                  child: const Text('Обновить'),
                ),
              ],
            ),
          );
        }
        // Данные есть — список книг
        final books = (state as BooksLoadSuccess).books;

        final displayedBooks = _showOnlyFavorites
            ? books.where((book) => _favoriteIds.contains(book.id)).toList()
            : books;

        if (displayedBooks.isEmpty) {
          // Форму показываем даже при пустом списке
          return Column(
            children: [
              if (_showForm) _buildAddForm(),
              const Expanded(child: Center(child: Text('Ничего не нашлось'))),
            ],
          );
        }

        return Column(
          children: [
            if (_showForm) _buildAddForm(),
            Expanded(
              child: ListView.builder(
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
                        if (id == null) {
                          return; // у книги нет id — лайк не ставим
                        }
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
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _signOut,
          ),
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
}
