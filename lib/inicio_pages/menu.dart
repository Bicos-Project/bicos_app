import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'perfil.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CABEÇALHO COM LOGO ---
              Row(
                children: [
                  Image.asset(
                    'assets/bicos_logo1.png',
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bicos',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.destaque,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- LINHA DIVISÓRIA ---
              Divider(color: AppColors.branco.withOpacity(0.15), thickness: 1),

              const SizedBox(height: 24),

              // --- CARD DE PERFIL ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF46295C,
                  ), // Um roxo levemente mais claro
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.branco.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    // A Foto do Perfil
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.destaque,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/vera.png', 
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Nome e Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mariana Oliveira',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.branco,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'mariana.o@example.com',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.branco.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- BOTÕES DO MENU ---
              _construirBotaoMenu(
                icone: Icons.account_circle_outlined,
                titulo: 'Perfil',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PerfilPage()),
                  );
                },
              ),
              const SizedBox(height: 16),

              _construirBotaoMenu(
                icone: Icons.settings_outlined,
                titulo: 'Configurações',
                onTap: () {
                  print("Clicou em Configurações");
                },
              ),

              const SizedBox(height: 16),

              _construirBotaoMenu(
                icone: Icons.logout_outlined,
                titulo: 'Sair',
                ehSair:
                    true,
                onTap: () {
                  print("Clicou em Sair");

                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- A "RECEITA" DOS BOTÕES DE MENU ---
  Widget _construirBotaoMenu({
    required IconData icone,
    required String titulo,
    required VoidCallback onTap,
    bool ehSair = false,
  }) {

    final corFundo = ehSair
        ? const Color(0xFF6B2745)
        : const Color(0xFF46295C);
    final corBorda = ehSair
        ? Colors.transparent
        : AppColors.branco.withOpacity(0.1);
    final corIcone = ehSair
        ? const Color(0xFFFF9EAA)
        : AppColors.destaque; 

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: corBorda),
        ),
        child: Row(
          children: [
            Icon(icone, color: corIcone, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.branco,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.branco.withOpacity(0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
