import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class HistoricoServicos extends StatelessWidget {
  const HistoricoServicos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Column(
          children: [
            _construirHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: AppColors.branco.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum serviço realizado ainda',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco.withOpacity(0.5),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quando você contratar um serviço,\nele aparecerá aqui',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco.withOpacity(0.3),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirHeader() {
    return Stack(
      children: [
        Image.asset('assets/header.png', fit: BoxFit.fill),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/bicos_logo2.png', height: 32),
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: AppColors.destaque,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Histórico',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
