import 'package:flutter/material.dart';
import 'package:random_selection_text_animation/random_selection_text_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Random Selection Text Animation'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: const [
            LetterSelectionAnimatedText(
              textWidget: Text(
                "HELLO",
                style: TextStyle(fontFamily: 'Courier New', fontSize: 50),
              ),
              charSets: {CharSet.englishAlphabetUpperCase},
            ),
            LetterSelectionAnimatedText(
              textWidget: Text(
                "FLUTTER",
                style: TextStyle(fontSize: 80),
              ),
              charSets: {CharSet.digits},
              framesPerSymbolChange: 4,
            ),
            LetterSelectionAnimatedText(
              textWidget: Text(
                "community",
                style: TextStyle(
                  fontFamily: 'Monospace',
                  fontSize: 30,
                ),
              ),
              charSets: {CharSet.custom},
              customCharSet: '0_oO',
              framesPerSymbolChange: 7,
              symbolChangesPerPosition: 7,
              timeLimit: Duration(seconds: 10),
            ),
          ],
        ),
      ),
    );
  }
}
