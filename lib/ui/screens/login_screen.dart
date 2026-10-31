import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorCode;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Вход существующего пользователя
  Future<void> _signIn() async {
    setState(() {
      _errorCode = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Успешный вход сам переключает экран (authStateChanges в main.dart)
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
    } catch (e) {
      setState(() {
        _errorCode = e.toString();
      });
    }
  }

  // Регистрация нового пользователя (только тестовые почты!)
  Future<void> _signUp() async {
    setState(() {
      _errorCode = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
    } catch (e) {
      setState(() {
        _errorCode = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _signIn,
                    child: const Text('Войти'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Зарегистрироваться'),
                  ),
                ],
              ),
              if (_errorCode != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Ошибка: $_errorCode',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
