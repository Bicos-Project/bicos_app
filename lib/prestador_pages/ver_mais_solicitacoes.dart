import 'package:flutter/material.dart';

class VerMaisSolicitacoesPage extends StatefulWidget {
  const VerMaisSolicitacoesPage({Key? key}) : super(key: key);

  @override
  State<VerMaisSolicitacoesPage> createState() => _VerMaisSolicitacoesState();
}

class _VerMaisSolicitacoesState extends State<VerMaisSolicitacoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ver Mais Solicitações')),
      body: Center(child: Text('Solicitações')),
    );
  }
}
