import 'package:flutter/material.dart';

class HistoricoServicoRealizadoPage extends StatefulWidget {
  const HistoricoServicoRealizadoPage({super.key});

  @override
  State<HistoricoServicoRealizadoPage> createState() =>
      _HistoricoServicoRealizadoPageState();
}

class _HistoricoServicoRealizadoPageState
    extends State<HistoricoServicoRealizadoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Serviço Realizado')),
      body: const Center(child: Text('Histórico de Serviço Realizado')),
    );
  }
}
