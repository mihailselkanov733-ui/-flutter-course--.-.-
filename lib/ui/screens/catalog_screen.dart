import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/books_bloc.dart';
import '../../bloc/books_event.dart';
import '../../bloc/books_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../widgets/book_card.dart';
import 'add_book_sheet.dart';
import 'book_details_screen.dart';

// Экран каталога: данные приходят только из BooksBloc,
// никаких запросов к Firestore здесь нет и лайки тоже в Bloc
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            // Выход через репозиторий: authStateChanges вернёт нас на экран входа
            onPressed: () => context.read<AuthRepository>().signOut(),
          ),
        ],
      ),
      // Добавление — в bottom sheet (вариант из задания)
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
        onPressed: () => _openAddSheet(context),
      ),
      body: Column(
        children: [
          // Опция «Поиск»: фильтрует список прямо во время ввода
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Поиск по названию',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) =>
                  context.read<BooksBloc>().add(BooksSearchChanged(query)),
            ),
          ),
          BlocBuilder<BooksBloc, BooksState>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Только избранные'),
                value: state is BooksLoadSuccess && state.favoritesOnly,
                onChanged: (value) => context
                    .read<BooksBloc>()
                    .add(BooksFavoritesOnlyChanged(value)),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<BooksBloc, BooksState>(
              builder: (context, state) {
                // Пока идёт загрузка — индикатор
                if (state is BooksLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Ошибка — понятный текст и кнопка «Обновить», приложение не падает
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
                          onPressed: () => context
                              .read<BooksBloc>()
                              .add(BooksLoadRequested()),
                          child: const Text('Обновить'),
                        ),
                      ],
                    ),
                  );
                }
                // Данные есть — рисуем список
                final success = state as BooksLoadSuccess;
                final displayedBooks = success.displayedBooks;

                // Пустое состояние: каталог пуст, фильтр не нашёл ничего
                // или поиск не дал результатов
                if (displayedBooks.isEmpty) {
                  final String message;
                  if (success.books.isEmpty) {
                    message =
                        'Каталог пуст. Нажмите «Добавить», чтобы создать первую книгу';
                  } else if (success.searchQuery.isNotEmpty) {
                    message =
                        'Ничего не нашлось по запросу «${success.searchQuery}»';
                  } else {
                    message = 'В избранном пока пусто';
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: displayedBooks.length,
                  itemBuilder: (context, index) {
                    final book = displayedBooks[index];
                    final id = book.id;
                    if (id == null) {
                      return const SizedBox.shrink(); // без id карточек не бывает
                    }
                    return BookCard(
                      book: book,
                      isFavorite: success.favoriteIds.contains(id),
                      onLikeTap: () => context
                          .read<BooksBloc>()
                          .add(BooksFavoriteToggled(id)),
                      onTap: () {
                        // Навигация на экран деталей.
                        // Bloc передаём тем же экземпляром — он один
                        // для списка и деталей, поэтому лайк совпадает
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<BooksBloc>(),
                              child: BookDetailsScreen(book: book),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // чтобы клавиатура не сжимала форму
      // Bloc прокидываем в sheet — иначе в шите не найти BlocProvider
      builder: (_) => BlocProvider.value(
        value: context.read<BooksBloc>(),
        child: const AddBookSheet(),
      ),
    );
  }
}
