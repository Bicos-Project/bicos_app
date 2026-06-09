import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import 'sobre_app.dart';

class TelaInicialPage extends StatelessWidget {
  const TelaInicialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
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