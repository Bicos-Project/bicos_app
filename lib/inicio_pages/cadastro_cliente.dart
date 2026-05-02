import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../components/main_navigation_cliente.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  bool _senhaOculta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Tela de Cadastro para Clientes
      body: SafeArea(
        child: Center( // Centraliza o conteúdo
          child: SingleChildScrollView( // Permite rolagem caso o teclado cubra os campos
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column( // Coluna para organizar os campos verticalmente
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/bicos_logo1.png', height: 60),

                const SizedBox(height: 16), // Espaço entre logo e texto

                RichText( // Texto de boas-vindas com estilo
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      color: AppColors.branco,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    children: [ // O texto "Bem vindo ao Bicos!" com "Bicos" em destaque
                      const TextSpan(text: 'Bem vindo\nao '),
                      TextSpan(
                        text: 'Bicos',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const TextSpan(text: '!'),
                    ],
                  ),
                ),

                const SizedBox(height: 32), 

                _construirLabel('Nome'), // Label para o campo de nome
                _construirCampoTexto(
                  dica: 'Digite seu nome',
                  icone: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                _construirLabel('E-mail'),  // Label para o campo de e-mail
                _construirCampoTexto(
                  dica: 'Digite seu e-mail',
                  icone: Icons.alternate_email,
                ),

                const SizedBox(height: 16),

                _construirLabel('CPF'), // Label para o campo de CPF
                _construirCampoTexto(
                  dica: 'Ex: 000.000.000-00',
                  icone: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                _construirLabel('Senha'), // Label para o campo de senha
                _construirCampoTexto(
                  dica: '••••••••••••',
                  icone: Icons.lock_outline,
                  esSenha: true,
                ),

                const SizedBox(height: 16),

                _construirLabel('CEP'),   // Label para o campo de CEP
                _construirCampoTexto(
                  dica: 'Ex: 00000-00',
                  icone: Icons.home_outlined,
                ),

                const SizedBox(height: 16),

                _construirLabel('Logradouro'), // Label para o campo de logradouro
                _construirCampoTexto(
                  dica: 'Ex: Rua dos engenhos',
                  icone: Icons.home_outlined,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded( // Lado a lado para número e complemento
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _construirLabel('Número'), // Label para o campo de número
                          _construirCampoTexto(
                            dica: 'Ex: 12',
                            icone: Icons.home_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(  // Complemento (lado direito)
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _construirLabel('Complemento'),
                          _construirCampoTexto(
                            dica: 'Ex: CASA A',
                            icone: Icons.home_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                SizedBox( // Botão de criar perfil
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavigation(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3A70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Criar perfil',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                GestureDetector( // Link para a tela de login, com texto estilizado
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Já tem conta?\n'),
                        TextSpan(
                          text: 'Faça Login aqui!',
                          style: TextStyle(
                            color: AppColors.destaque,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirLabel(String texto) { // Widget para construir as labels dos campos de forma consistente
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          texto,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.branco,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _construirCampoTexto({ // Widget para construir os campos de texto de forma consistente
    required String dica,
    required IconData icone,
    bool esSenha = false,
  }) {
    return TextField(
      obscureText: esSenha ? _senhaOculta : false,
      style: const TextStyle(color: AppColors.principalEscura),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD2C3D9),
        hintText: dica,
        prefixIcon: Icon(icone, color: AppColors.principalEscura),
        suffixIcon: esSenha
            ? IconButton(
                icon: Icon(
                  _senhaOculta
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.principalEscura,
                ),
                onPressed: () {
                  setState(() {
                    _senhaOculta = !_senhaOculta;
                  });
                },
              )
            : null,
        border: OutlineInputBorder( // Borda customizada para os campos de texto
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
