import '../domain/entities/book_item.dart';

// События каталога — всё, чем пользователь может "попросить" Bloc
sealed class BooksEvent {}

// Загрузить каталог (первая загрузка и кнопка «Обновить»
// после ошибки)
class BooksLoadRequested extends BooksEvent {}

// Лайкнуть книгу / снять лайк
class BooksFavoriteToggled extends BooksEvent {
  final String bookId;

  BooksFavoriteToggled(this.bookId);
}

// Включить/выключить фильтр «Только избранные»
class BooksFavoritesOnlyChanged extends BooksEvent {
  final bool value;

  BooksFavoritesOnlyChanged(this.value);
}

// Изменить текст поиска
class BooksSearchChanged extends BooksEvent {
  final String query;

  BooksSearchChanged(this.query);
}

// Добавить книгу в каталог
class BooksBookAdded extends BooksEvent {
  final BookItem book;

  BooksBookAdded(this.book);
}
