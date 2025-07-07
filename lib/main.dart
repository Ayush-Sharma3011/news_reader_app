import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
