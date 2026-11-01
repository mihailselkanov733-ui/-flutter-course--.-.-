import '../domain/entities/book_item.dart';

// Три состояния каталога: загрузка, данные, ошибка.
sealed class BooksState {}

// Пока данных нет — на экране крутится индикатор.
class BooksLoadInProgress extends BooksState {}

// Данные загружены; дальше список сам обновляется из snapshots().
class BooksLoadSuccess extends BooksState {
  final List<BookItem> books;

  BooksLoadSuccess(this.books);
}

// Не удалось загрузить каталог (например, правила Firestore запрещают чтение).
class BooksLoadFailure extends BooksState {
  final String message;

  BooksLoadFailure(this.message);
}
