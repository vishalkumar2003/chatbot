import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:my_flutter_project/const.dart';
import 'package:my_flutter_project/page/home.dart';

void main() {
  Gemini.init(apiKey: OPEN_API);
  Gemini.instance.prompt(parts: [
    Part.text('Write a story about a magic backpack'),
  ]).then((value) {
    print(value?.output);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const home(),
    );
  }
}

