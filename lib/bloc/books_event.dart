// События BLoC каталога. По ДЗ 6 событие одно — запрос загрузки:
// обновления списка приходят сами через поток snapshots() из Firestore.
sealed class BooksEvent {}

class BooksLoadRequested extends BooksEvent {}
