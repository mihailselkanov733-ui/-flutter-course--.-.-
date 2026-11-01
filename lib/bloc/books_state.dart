import '../domain/entities/book_item.dart';

// Состояния каталога: загрузка, данные, ошибка.
sealed class BooksState {}

// Пока данных нет — на экране крутится индикатор.
class BooksLoadInProgress extends BooksState {}

// Каталог загружен. Вместе с книгами Bloc хранит лайки текущего
// пользователя (users/<uid> в Firestore), фильтр и текст поиска,
// поэтому сердечко на деталях и в списке всегда совпадает
class BooksLoadSuccess extends BooksState {
  final List<BookItem> books;
  final Set<String> favoriteIds;

  // Фильтр «Только избранные»
  final bool favoritesOnly;

  // Текущий текст поиска (опция «Поиск»)
  final String searchQuery;

  BooksLoadSuccess({
    required this.books,
    required this.favoriteIds,
    this.favoritesOnly = false,
    this.searchQuery = '',
  });

  // Что показывать в списке: применяем поиск без учёта регистра,
  // затем фильтр «Только избранные»
  List<BookItem> get displayedBooks {
    var result = books;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where((book) => book.title.toLowerCase().contains(query))
          .toList();
    }
    if (favoritesOnly) {
      result = result
          .where((book) => favoriteIds.contains(book.id))
          .toList();
    }
    return result;
  }
}

// Не удалось загрузить каталог (например, нет интернета)
class BooksLoadFailure extends BooksState {
  final String message;

  BooksLoadFailure(this.message);
}
