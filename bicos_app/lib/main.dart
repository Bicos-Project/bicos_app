import 'package:flutter/material.dart';
// Importando a nossa tela inicial! (Ajuste o caminho da pasta se precisar)
import 'inicio_pages/tela_inicial.dart'; 
import 'inicio_pages/menu.dart';
void main() {
  runApp(const BicosApp());
}

class BicosApp extends StatelessWidget {
  const BicosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bicos',
      // Essa linha tira aquela faixa vermelha de "DEBUG" do canto da tela
      debugShowCheckedModeBanner: false, 
      
      // Aqui está o segredo: dizendo qual é a tela inicial de verdade
      home: const TelaInicial(), 
    );
  }
}