import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'escolha_perfil.dart';

class SobreAppPage extends StatelessWidget {
  const SobreAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // --- A FOTO COM O CARD FLUTUANTE ---
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/trabalhador.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned( // O card flutuante --- IGNORE ---
                    bottom: -20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.branco,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row( // O conteúdo do card flutuante --- IGNORE ---
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.destaque.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.principal,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOCALIZAÇÃO', // O texto "LOCALIZAÇÃO" dentro do card flutuante --- IGNORE ---
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text( // O texto "Próximo a você" dentro do card flutuante --- IGNORE ---
                                'Próximo a você',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.principalEscura,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 56),

              // --- O TÍTULO ---
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Encontre o bico perfeito\n',
                      style: TextStyle(color: AppColors.destaque),
                    ),
                    TextSpan(
                      text: 'perto de você',
                      style: TextStyle(color: AppColors.branco),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- O SUBTÍTULO ---
              Text(
                'Conectamos você aos melhores prestadores\nde serviço da sua comunidade de forma\nsimples e segura.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.branco.withOpacity(0.8),
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // --- OS PONTINHOS DE PAGINAÇÃO ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _construirBolinha(ativa: true),
                  const SizedBox(width: 8),
                  _construirBolinha(ativa: false),
                  const SizedBox(width: 8),
                  _construirBolinha(ativa: false),
                ],
              ),

              const SizedBox(height: 24),

              // --- O BOTÃO PRÓXIMO ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EscolhaPerfil(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.destaque,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Próximo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.principalEscura,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.principalEscura,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirBolinha({required bool ativa}) {
    return Container(
      height: 6,
      width: ativa ? 24 : 6,
      decoration: BoxDecoration(
        color: ativa ? AppColors.destaque : AppColors.branco.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
