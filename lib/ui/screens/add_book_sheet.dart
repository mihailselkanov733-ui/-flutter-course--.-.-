import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/books_bloc.dart';
import '../../bloc/books_event.dart';
import '../../domain/entities/book_item.dart';

// Bottom sheet добавления книги. Открывается по кнопке «Добавить».
// Обязательное поле одно — «Название», пустое название не отправляется
class AddBookSheet extends StatefulWidget {
  const AddBookSheet({super.key});

  @override
  State<AddBookSheet> createState() => _AddBookSheetState();
}

class _AddBookSheetState extends State<AddBookSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Отправка: добавлением заведует Bloc (через репозиторий — Firestore)
  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return; // пустое название не отправляем

    // Messenger запоминаем до закрытия шита — после pop контекст шита уйдёт
    final messenger = ScaffoldMessenger.of(context);

    context.read<BooksBloc>().add(
          BooksBookAdded(
            BookItem(
              title: title,
              author: _authorController.text.trim(),
              year: _yearController.text.trim(),
              genre: _genreController.text.trim(),
              description: _descriptionController.text.trim(),
            ),
          ),
        );

    Navigator.of(context).pop(); // закрыть sheet и вернуться к списку
    messenger.showSnackBar(
      const SnackBar(content: Text('Книга добавлена — она появится в списке')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Новая книга',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Название *',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _authorController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Автор',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Год',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _genreController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Жанр',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Добавить книгу'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
