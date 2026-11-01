import 'package:flutter/material.dart';

// Обложка-заглушка: в новых проектах Firebase Storage требует платный тариф,
// поэтому обложки — это цветной контейнер с первой буквой названия
class BookCover extends StatelessWidget {
  final String title;
  final double size;
  final double fontSize;

  const BookCover({
    super.key,
    required this.title,
    this.size = 56,
    this.fontSize = 24,
  });

  // Цвет обложки выбирается по первой букве названия:
  // одна и та же книга всегда с одной и той же обложкой
  static const List<Color> _palette = [
    Color(0xFF3F51B5),
    Color(0xFF00897B),
    Color(0xFFE53935),
    Color(0xFFF57C00),
    Color(0xFF7B1FA2),
    Color(0xFF0288D1),
    Color(0xFF388E3C),
    Color(0xFF5D4037),
  ];

  @override
  Widget build(BuildContext context) {
    final firstCode = title.isEmpty ? 63 : title.runes.first; // 63 = «?»
    final letter = String.fromCharCode(firstCode).toUpperCase();
    final color = _palette[firstCode % _palette.length];

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 6),
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Иконка категории — одинаковая в карточке и на экране деталей
IconData iconForGenre(String genre) {
  switch (genre.toLowerCase()) {
    case 'фантастика':
    case 'фэнтези':
      return Icons.auto_awesome;
    case 'детектив':
      return Icons.search;
    case 'приключения':
      return Icons.explore;
    case 'поэзия':
      return Icons.music_note;
    case 'история':
      return Icons.history_edu;
    default:
      return Icons.menu_book;
  }
}
