import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SeJogaApp());
}

class SeJogaApp extends StatelessWidget {
  const SeJogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeJoga 2025',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

