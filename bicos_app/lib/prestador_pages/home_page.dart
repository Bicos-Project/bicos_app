import 'package:flutter/material.dart';
import 'package:bicos_app/prestador_pages/anunciar_servico.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/header.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
*/
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnunciarServicoPage(),
              ),
            );
          },
          child: const Text('Ir para anunciar'),
        ),
      ),
    );

  }
}
