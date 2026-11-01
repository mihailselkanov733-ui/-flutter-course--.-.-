import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/book_item.dart';
import '../domain/repositories/books_repository.dart';
import 'books_event.dart';
import 'books_state.dart';

// BLoC каталога: единственный, кто общается с BooksRepository.
// Виджеты ничего не знают о Firestore — только шлют события и рисуют состояние
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc(this._repository) : super(BooksLoadInProgress()) {
    on<BooksLoadRequested>(_onLoadRequested);
    on<BooksFavoriteToggled>(_onFavoriteToggled);
    on<BooksFavoritesOnlyChanged>(_onFavoritesOnlyChanged);
    on<BooksSearchChanged>(_onSearchChanged);
    on<BooksBookAdded>(_onBookAdded);
  }

  final BooksRepository _repository;

  // Актуальные лайки, фильтр и поиск хранятся в Bloc, чтобы
  // не теряться между порциями данных из потока snapshots()
  Set<String> _favoriteIds = const {};
  bool _favoritesOnly = false;
  String _searchQuery = '';

  // Загрузка (или перезагрузка после «Обновить»)
  Future<void> _onLoadRequested(
    BooksLoadRequested event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadInProgress());

    // Лайки хранятся отдельно от каталога — подтягиваем их для текущего пользователя,
    // после каждого входа и на каждом «Обновить»
    try {
      _favoriteIds = await _repository.loadFavoriteIds();
    } catch (_) {
      // без интернета сюда попасть не страшно:
      // ошибка придёт ниже из потока каталога
    }

    await emit.forEach(
      _repository.watchBooks(),
      onData: (List<BookItem> books) => _success(books),
      onError: (error, stackTrace) =>
          BooksLoadFailure('Не удалось загрузить каталог'),
    );
  }

  // Лайк: меняем сердечко сразу, затем сохраняем в Firestore
  Future<void> _onFavoriteToggled(
    BooksFavoriteToggled event,
    Emitter<BooksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BooksLoadSuccess) return;

    final updated = Set<String>.from(_favoriteIds);
    final isFavoriteNow = updated.contains(event.bookId);
    if (isFavoriteNow) {
      updated.remove(event.bookId);
    } else {
      updated.add(event.bookId);
    }
    _favoriteIds = updated;
    emit(_success(currentState.books));

    try {
      await _repository.setFavorite(event.bookId, favorite: !isFavoriteNow);
    } catch (_) {
      // не записалось (например, пропал интернет) —
      // после перезагрузки сердечко вернётся в состояние из Firestore
    }
  }

  // Фильтр «Только избранные»
  Future<void> _onFavoritesOnlyChanged(
    BooksFavoritesOnlyChanged event,
    Emitter<BooksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BooksLoadSuccess) return;

    _favoritesOnly = event.value;
    emit(_success(currentState.books));
  }

  // Поиск по названию
  Future<void> _onSearchChanged(
    BooksSearchChanged event,
    Emitter<BooksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BooksLoadSuccess) return;

    _searchQuery = event.query;
    emit(_success(currentState.books));
  }

  // Добавление книги: сам документ создаёт репозиторий,
  // а в список новый элемент приедет сам через поток snapshots()
  Future<void> _onBookAdded(
    BooksBookAdded event,
    Emitter<BooksState> emit,
  ) async {
    await _repository.addBook(event.book);
  }

  // Свежее состояние успеха с текущими лайками/фильтрами/поиском
  BooksLoadSuccess _success(List<BookItem> books) {
    return BooksLoadSuccess(
      books: books,
      favoriteIds: _favoriteIds,
      favoritesOnly: _favoritesOnly,
      searchQuery: _searchQuery,
    );
  }
}
