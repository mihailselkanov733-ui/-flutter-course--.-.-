import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entities/book_item.dart';

// Репозиторий каталога: единственное место в приложении, где
// код работает с Firestore. Bloc ходит только сюда,
// виджеты к Firebase напрямую не обращаются.
class BooksRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Поток каталога: каждая порция из базы превращается в список моделей.
  // После добавления/изменения документа список приедет сам
  Stream<List<BookItem>> watchBooks() {
    return _firestore.collection('books').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => BookItem.fromFirestore(doc)).toList(),
        );
  }

  // Разовое чтение лайков текущего пользователя из users/<uid>
  Future<Set<String>> loadFavoriteIds() async {
    final doc = await _favoriteDoc().get();
    final raw = doc.data()?['favoriteIds'];
    if (raw is List) {
      return raw.map((entry) => entry.toString()).toSet();
    }
    return <String>{};
  }

  // Записать лайк: в документе users/<uid> хранится список id избранных книг.
  // set c merge:true сам создаст документ, если его ещё нет,
  // поэтому можно смело использовать arrayUnion / arrayRemove
  Future<void> setFavorite(String bookId, {required bool favorite}) async {
    await _favoriteDoc().set(
      {
        'favoriteIds': favorite
            ? FieldValue.arrayUnion([bookId])
            : FieldValue.arrayRemove([bookId]),
      },
      SetOptions(merge: true),
    );
  }

  // Добавление книги: Firestore сам выдаёт id нового документа,
  // а поток watchBooks разнесёт её по всем экранам
  Future<void> addBook(BookItem book) {
    return _firestore.collection('books').add(book.toJson());
  }

  // Документ пользователя с его лайками: users/<uid>
  DocumentReference<Map<String, dynamic>> _favoriteDoc() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore.collection('users').doc(uid);
  }
}
