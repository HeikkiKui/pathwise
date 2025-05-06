// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const PathwiseApp());
}

class PathwiseApp extends StatelessWidget {
  const PathwiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathwise',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathwise')),
      body: const Center(
        child: Text('Syötä oppimistavoitteesi'),
      ),
    );
  }
}

