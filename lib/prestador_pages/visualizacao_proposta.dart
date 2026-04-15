import 'package:flutter/material.dart';

// 1. A classe Widget
class VisualizacaoPropostaPage extends StatefulWidget {
  const VisualizacaoPropostaPage({super.key});

  @override
  State<VisualizacaoPropostaPage> createState() =>
      _VisualizacaoPropostaPageState();
}

// 2. A classe de Estado (geralmente privada com _)
class _VisualizacaoPropostaPageState extends State<VisualizacaoPropostaPage> {
  int _contador = 0; // Exemplo de variável de estado

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Função para atualizar o estado
        setState(() {
          _contador++;
        });
      },
      child: Text('Contagem: $_contador'),
    );
  }
}
