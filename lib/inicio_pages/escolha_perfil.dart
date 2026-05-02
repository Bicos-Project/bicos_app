import 'package:bicos_app/inicio_pages/cadastro_prestador.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'login_cliente.dart';

class EscolhaPerfil extends StatelessWidget {
  const EscolhaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // --- O TÍTULO ---
              RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Como você quer ',
                      style: TextStyle(color: AppColors.branco),
                    ),
                    TextSpan(
                      text: 'começar hoje?',
                      style: TextStyle(color: AppColors.destaque),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // --- O SUBTÍTULO ---
              Text(
                'Selecione o perfil que melhor descreve\nseu objetivo na plataforma Bicos.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.branco.withOpacity(0.8),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // --- CARD 1: SOU CLIENTE ---
              _construirCardPerfil(
                icon: Icons.person_search_outlined,
                iconBgColor: const Color(0xFFE8E0F0),
                iconColor: AppColors.principal,
                title: 'Quero Contratar',
                description:
                    'Procuro por profissionais qualificados e confiáveis para realizar serviços na minha residência ou empresa.',
                buttonText: 'Sou Cliente',
                onPressed: () {
                  // NAVEGANDO PARA O LOGIN
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),

              const SizedBox(height: 24),

              // --- CARD 2: SOU PROFISSIONAL ---
              _construirCardPerfil(
                icon: Icons.work_outline,
                iconBgColor: AppColors.destaque,
                iconColor: AppColors.principalEscura,
                title: 'Quero Trabalhar',
                description:
                    'Sou um prestador de serviços e quero oferecer minhas habilidades para encontrar novos clientes e oportunidades.',
                buttonText: 'Sou Profissional',
                onPressed: () {
                  // AGORA TAMBÉM NAVEGA PARA O LOGIN!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPrestadorPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A "Receita" do Card
  Widget _construirCardPerfil({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.principalEscura,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.principal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.principal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.principal,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
