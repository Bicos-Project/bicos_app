import 'package:flutter/material.dart';
import './inicio_pages/tela_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 PRIMEIRA TELA DO APP
      home: const TelaInicial(),
    );
  }
}
