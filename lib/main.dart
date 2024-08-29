// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/client_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Client Management',
      home: ClientListPage(),
    );
  }
}
