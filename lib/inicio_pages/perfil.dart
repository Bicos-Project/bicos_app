import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      // A mágica da barra inferior conectada direto no Scaffold
      bottomNavigationBar: _construirBottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- CABEÇALHO (LOGO E AVATAR PEQUENO) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/bicos_logo1.png', height: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Bicos',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.destaque,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage('assets/avatar_mariana.png'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- BOTÃO VOLTAR E FOTO GRANDE ---
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.branco,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Volta pra tela anterior
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.destaque, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/avatar_mariana.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- NOME E ÍCONE DE EDITAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mariana Oliveira Silva',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.branco,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, color: AppColors.branco, size: 16),
                ],
              ),
              const SizedBox(height: 32),

              // --- CAMPOS DE DADOS ---
              _construirCampo(
                'E-mail',
                'mariana.o@example.com',
                editavel: true,
              ),
              const SizedBox(height: 16),
              _construirCampo(
                'CPF',
                '133.••••••-13',
                editavel: false,
              ), // Sem lápis
              const SizedBox(height: 16),
              _construirCampo('CEP', '51320-165', editavel: true),
              const SizedBox(height: 16),
              _construirCampo(
                'Logradouro',
                'Rua dos Engenhos',
                editavel: false,
              ), // Sem lápis
              const SizedBox(height: 16),

              // --- NÚMERO E COMPLEMENTO (Lado a Lado) ---
              Row(
                children: [
                  Expanded(
                    child: _construirCampo('Número', '12', editavel: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _construirCampo(
                      'Complemento',
                      'S/C',
                      editavel: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- RECEITA DOS CAMPOS ESCUROS ---
  Widget _construirCampo(String label, String valor, {required bool editavel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.branco,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF262626), // O fundo bem escuro que você usou
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                valor,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.branco.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              if (editavel)
                Icon(
                  Icons.edit,
                  color: AppColors.branco.withOpacity(0.5),
                  size: 16,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // --- RECEITA DA BARRA DE NAVEGAÇÃO INFERIOR ---
  Widget _construirBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF46295C), // O roxo da barra
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: AppColors.branco.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconeBottomBar(Icons.favorite_border, 'FAVORITOS'),
          _iconeBottomBar(Icons.home_outlined, 'HOME'),
          _iconeBottomBar(Icons.menu, 'MENU'),
          _iconeBottomBar(Icons.history, 'HISTÓRICO'),
        ],
      ),
    );
  }

  Widget _iconeBottomBar(IconData icone, String texto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, color: AppColors.branco.withOpacity(0.7), size: 24),
        const SizedBox(height: 4),
        Text(
          texto,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.branco.withOpacity(0.7),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
