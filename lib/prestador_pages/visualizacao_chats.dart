import 'package:flutter/material.dart';

class VisualizacaoChats extends StatefulWidget {
  const VisualizacaoChats({super.key});

  @override
  State<VisualizacaoChats> createState() => _VisualizacaoChatsState();
}

class _VisualizacaoChatsState extends State<VisualizacaoChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: const Center(child: Text('Aqui serão listados os chats ativos.')),
    );
  }
}
