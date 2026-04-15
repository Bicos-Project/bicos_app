import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import 'sobre_app.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      // O GestureDetector cobrindo a tela toda para avançar com 1 toque
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SobreApp()),
          );
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Linha para colocar a Logo e o nome "Bicos" lado a lado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/bicos_logo1.png',
                    height: 80, // Ajuste a altura da logo se precisar
                  ),
                  const SizedBox(width: 16), // Espaço entre a logo e o texto
                  Text(
                    'Bicos',
                    // Usando a fonte gigante e pintando com o verde de destaque
                    style: AppTextStyles.tituloGigante.copyWith(
                      color: AppColors.destaque,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Espaço para o subtítulo
              // O Subtítulo
              Text(
                'Transformando a sua\ncomunidade.',
                textAlign: TextAlign.center,
                style: AppTextStyles.textoPadrao, // A fonte branca menorzinha
              ),
            ],
          ),
        ),
      ),
    );
  }
}
