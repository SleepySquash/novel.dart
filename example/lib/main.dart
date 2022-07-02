import 'package:flutter/material.dart';
import 'package:novel/novel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Novels')),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Simple novel'),
                onTap: () {
                  Novel.show(
                    context: context,
                    scenario: [
                      //
                      BackgroundLine('apartment_day.jpg'),
                      DialogueLine('Я сидел, пил пепси колу.'),
                      DialogueLine(
                          'День был очень жаркий, не хотелось ничего делать.'),
                      DialogueLine('Кола кончилась.'),
                      DialogueLine('Ну бля...', by: 'Я'),
                      const WaitLine(Duration(seconds: 1)),
                      DialogueLine('Ладно, схожу за новой.', by: 'Я'),

                      //
                      BackgroundLine('city_day.jpg'),
                      const WaitLine(Duration(seconds: 1)),
                      DialogueLine('На улице, как всегда, очень шумно.'),
                      DialogueLine('Люди бегают туда-сюда, солнце печёт.'),
                      DialogueLine('Уже совсем рядом с магазином...'),
                      CharacterLine('72946537_p5.png'),
                      DialogueLine('А-ай!!', by: 'Тян'),
                      DialogueLine('П-прошу прощения!', by: 'Я'),
                      DialogueLine('Смотри, куда идёшь! Бака!', by: 'Тян'),
                      DialogueLine(
                          'Как обычно, задумавшись о своём, я не заметил, куда шёл и случайно чуть не сбил с ног эту очаровашку.'),
                      HideCharacterLine('72946537_p5.png'),
                      DialogueLine(
                          'Опустив голову ниже плинтуса, я пошёл дальше...'),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
