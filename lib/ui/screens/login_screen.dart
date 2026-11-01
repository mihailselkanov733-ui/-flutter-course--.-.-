import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Вход существующего пользователя
  Future<void> _signIn() async {
    final authRepository = context.read<AuthRepository>();
    if (mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
    try {
      await authRepository.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      // Успешный вход сам переключает экран (authStateChanges в AuthGate)
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = authRepository.friendlyError(error);
        });
      }
    }
  }

  // Регистрация нового пользователя
  Future<void> _signUp() async {
    final authRepository = context.read<AuthRepository>();
    if (mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
    try {
      await authRepository.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = authRepository.friendlyError(error);
        });
      }
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
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
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
