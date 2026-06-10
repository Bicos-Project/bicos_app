import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../components/main_navigation_cliente.dart';
import '../components/main_navigation_prestador.dart';

class ServicoConcluidoPage extends StatefulWidget {
  final bool isPrestador;

  const ServicoConcluidoPage({super.key, this.isPrestador = false});

  @override
  State<ServicoConcluidoPage> createState() => _ServicoConcluidoPageState();
}

class _ServicoConcluidoPageState extends State<ServicoConcluidoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _voltarAoInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => widget.isPrestador
            ? const MainNavigationPrestador()
            : const MainNavigation(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.destaque,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.destaque.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, size: 50, color: AppColors.principalEscura),
                ),
              ),
              FadeTransition(
                opacity: _opacityAnim,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Serviço Concluído!',
                      style: TextStyle(
                        color: AppColors.branco,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sua avaliação foi enviada com sucesso.',
                      style: TextStyle(
                        color: AppColors.branco.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _voltarAoInicio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.destaque,
                        foregroundColor: AppColors.principalEscura,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Voltar ao início',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
