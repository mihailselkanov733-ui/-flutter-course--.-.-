// ЛР 1 — шесть независимых виджетов.
//
// Как сдавать: скопируйте этот файл целиком себе в main.dart, допишите
// шесть функций ниже вместо TODO, запустите — все шесть элементов должны
// появиться на экране. Пришлите готовый файл на проверку.
//
// Основной виджет трогать не нужно. Редактируйте там, где написано TODO.

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ЛР 1')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task 1:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task1(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 2:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task2(),

              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 3:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task3(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 4:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task4(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 5:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task5(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 6:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task6(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок — крупный жирный текст чёрного цвета, обрезается в одну строку
Widget task1() {
  return Text(
    'Заголовок лабораторной работы',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

// 2. Подпись — небольшой нежирный курсивный текст белого цвета в тёмно-сером контейнере
Widget task2() {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.grey[850], // Тёмно-серый цвет подложки
      borderRadius: BorderRadius.circular(8.0), // Закругления
    ),
    child: Text(
      'Небольшой курсивный текст белого цвета, который при переполнении обрезается максимум в две строки.',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    ),
  );
}

// 3. Иконка — любая иконка с цветом и размером
Widget task3() {
  return Icon(
    Icons.bolt, // Иконка молнии (или любая другая, например Icons.star)
    color: Colors.orange,
    size: 48,
  );
}

// 4. Кнопка с иконкой избранного — большая красная иконка сердца без фона
Widget task4() {
  return IconButton(
    icon: const Icon(Icons.favorite),
    color: Colors.red,
    iconSize: 48,
    onPressed: () {
      print('Вы добавили в избранное');
    },
  );
}

// 5. Кнопка «Подробнее» — кнопка с текстом и обводкой
Widget task5() {
  return OutlinedButton(
    onPressed: () {
      print('Узнать детали');
    },
    child: const Text('Подробнее'),
  );
}

// 6. Изображение в стиле Polaroid — чёрная обводка снаружи, белая подложка внутри
Widget task6() {
  return Container(
    padding: const EdgeInsets.all(3.0), // Чёрная рамка снаружи
    color: Colors.black,
    child: Container(
      padding: const EdgeInsets.fromLTRB(
        12.0,
        12.0,
        12.0,
        36.0,
      ), // Белая подложка (снизу шире для стиля Polaroid)
      color: Colors.white,
      child: Image.network(
        'https://img.magnific.com/free-photo/photorealistic-style-clouds_23-2151058953.jpg?semt=ais_hybrid&w=740&q=80',
        width: 200,
        height: 150,
        fit: BoxFit.cover,
      ),
    ),
  );
}
