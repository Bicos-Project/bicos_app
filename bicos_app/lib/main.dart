import 'package:flutter/material.dart';
import 'prestador_pages/home_page.dart';

void main() {
  runApp(MaterialApp(home: HomePage(title: 'Bicos')));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ColorScheme bicosColorScheme = const ColorScheme(
    brightness: Brightness.dark,

    // Cor principal (roxo forte)
    primary: Color(0xFF8E24AA),
    onPrimary: Colors.white,

    // Variante da primária
    primaryContainer: Color(0xFF6A1B9A),
    onPrimaryContainer: Colors.white,

    // Cor secundária (verde destaque)
    secondary: Color(0xFFB2FF59),
    onSecondary: Colors.black,

    secondaryContainer: Color(0xFF7CB342),
    onSecondaryContainer: Colors.black,
    background: Color(0xFF1A001F),
    onBackground: Colors.white,

    // Cards / superfícies
    surface: Color(0xFF2A0033),
    onSurface: Colors.white,

    // Erro
    error: Colors.redAccent,
    onError: Colors.white,
  );
  final LinearGradient mainGradient = LinearGradient(
    colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAD2BE8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Bicos');
  }
}

