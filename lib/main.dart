import 'package:firebase_auth/firebase_auth.dart'; // тип User для StreamBuilder
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/books_bloc.dart';
import 'bloc/books_event.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/books_repository.dart';
import 'firebase_options.dart';
import 'ui/screens/catalog_screen.dart';
import 'ui/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализация Firebase (конфиг — в firebase_options.dart)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Репозиторий входа — один на всё приложение,
    // его читают AuthGate и экран входа
    return RepositoryProvider<AuthRepository>(
      create: (_) => AuthRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Каталог книг',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthGate(),
      ),
    );
  }
}

// Роутер по состоянию входа: без входа каталог недоступен
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    return StreamBuilder<User?>(
      // firebase_auth спрятан внутри репозитория — виджет лишь слушает поток
      stream: authRepository.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Вошёл — каталог под BlocProvider (Bloc создаётся и сразу
          // запрашивает загрузку), не вошёл — экран входа.
          // После перезапуска приложения сессия Firebase жива,
          // поэтому пользователь остаётся залогиненным без повторного ввода пароля
          return snapshot.hasData
              ? BlocProvider(
                  create: (_) =>
                      BooksBloc(BooksRepository())..add(BooksLoadRequested()),
                  child: const CatalogScreen(),
                )
              : const LoginScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
