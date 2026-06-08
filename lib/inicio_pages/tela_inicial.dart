import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/main_navigation_cliente.dart';
import '../components/main_navigation_prestador.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../providers/auth_provider.dart';
import 'sobre_app.dart';

class TelaInicialPage extends StatefulWidget {
  const TelaInicialPage({super.key});

  @override
  State<TelaInicialPage> createState() => _TelaInicialPageState();
}

class _TelaInicialPageState extends State<TelaInicialPage> {
  bool _checando = true;

  @override
  void initState() {
    super.initState();
    _verificarAuth();
  }

  Future<void> _verificarAuth() async {
    final auth = context.read<AuthProvider>();
    final logado = await auth.init();
    if (!mounted) return;

    if (logado) {
      _navegarHome(auth.perfil);
    } else {
      setState(() => _checando = false);
    }
  }

  void _navegarHome(String? perfil) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => perfil == 'PRESTADOR'
            ? const MainNavigationPrestador()
            : const MainNavigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checando) {
      return Scaffold(
        backgroundColor: AppColors.principal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/bicos_logo1.png', height: 80),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: AppColors.destaque),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.principal,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SobreAppPage()),
          );
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/bicos_logo1.png',
                    height: 80,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Bicos',
                    style: AppTextStyles.tituloGigante.copyWith(
                      color: AppColors.destaque,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Transformando a sua\ncomunidade.',
                textAlign: TextAlign.center,
                style: AppTextStyles.textoPadrao,
              ),
            ],
          ),
        ),
      ),
    );
  }
}