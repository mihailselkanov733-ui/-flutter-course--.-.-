import 'package:firebase_auth/firebase_auth.dart';

// Репозиторий входа: все вызовы firebase_auth живут здесь.
// Экран входа и роутер AuthGate общаются только с этим классом,
// а не с Firebase напрямую.
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Поток о входе и выходе: AuthGate по нему выбирает экран
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Вход существующего пользователя
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Регистрация нового аккаунта
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Выход: поток authStateChanges сам вернёт нас на экран входа
  Future<void> signOut() => _auth.signOut();

  // Человекопонятный текст ошибки вместо технического кода (e.code)
  String friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'В адресе почты есть опечатка. Проверьте его, пожалуйста';
        case 'wrong-password':
        case 'user-not-found':
        case 'invalid-credential':
          return 'Неверный email или пароль';
        case 'email-already-in-use':
          return 'Этот email уже зарегистрирован. Нажмите «Войти»';
        case 'weak-password':
          return 'Пароль слишком короткий — нужно минимум 6 символов';
        case 'user-disabled':
          return 'Этот аккаунт заблокирован';
        case 'too-many-requests':
          return 'Слишком много попыток подряд, подождите пару минут';
        case 'network-request-failed':
          return 'Нет подключения к интернету';
        case 'operation-not-allowed':
          return 'Вход по email и паролю отключён в настройках проекта';
      }
      return 'Ошибка (${error.code}). Попробуйте ещё раз';
    }
    return 'Что-то пошло не так. Попробуйте ещё раз';
  }
}
