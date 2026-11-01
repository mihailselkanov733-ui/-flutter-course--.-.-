import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/book_item.dart';
import 'books_event.dart';
import 'books_state.dart';

// BLoC каталога: единственный, кто читает коллекцию books из Firestore.
// На каждый BooksLoadRequested подписываемся на snapshots() —
// каждая порция данных из базы превращается в новое состояние,
// поэтому список обновляется сам (как в ДЗ 5, только уже через Bloc).
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  // Коллекция каталога — та же, что в ДЗ 5
  static const String _collectionName = 'books';

  BooksBloc() : super(BooksLoadInProgress()) {
    on<BooksLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    BooksLoadRequested event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadInProgress());
    await emit.forEach(
      FirebaseFirestore.instance.collection(_collectionName).snapshots(),
      onData: (snapshot) =>
          BooksLoadSuccess(snapshot.docs.map(BookItem.fromFirestore).toList()),
      onError: (error, stackTrace) =>
          BooksLoadFailure('Не удалось загрузить каталог'),
    );
  }
}
