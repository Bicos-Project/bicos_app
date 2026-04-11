import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  bool _senhaOculta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- A LOGO ---
                Image.asset(
                  'assets/bicos_logo1.png',
                  height: 60, // Deixei um pouco menor para caber tudo na tela
                ),
                const SizedBox(height: 16),

                // --- O TÍTULO ---
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      color: AppColors.branco,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    children: [
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

                // --- CAMPOS DO FORMULÁRIO ---
                
                _construirLabel('Nome'),
                _construirCampoTexto(dica: 'Digite seu nome', icone: Icons.person_outline),
                const SizedBox(height: 16),

                _construirLabel('E-mail'),
                _construirCampoTexto(dica: 'Digite seu e-mail', icone: Icons.alternate_email),
                const SizedBox(height: 16),

                _construirLabel('CPF'),
                _construirCampoTexto(dica: 'Ex: 000.000.000-00', icone: Icons.person_outline),
                const SizedBox(height: 16),

                _construirLabel('Senha'),
                _construirCampoTexto(dica: '••••••••••••', icone: Icons.lock_outline, esSenha: true),
                const SizedBox(height: 16),

                _construirLabel('CEP'),
                _construirCampoTexto(dica: 'Ex: 00000-00', icone: Icons.home_outlined),
                const SizedBox(height: 16),

                _construirLabel('Logradouro'),
                _construirCampoTexto(dica: 'Ex: Rua dos engenhos', icone: Icons.home_outlined),
                const SizedBox(height: 16),

                // --- NÚMERO E COMPLEMENTO LADO A LADO ---
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _construirLabel('Número'),
                          _construirCampoTexto(dica: 'Ex: 12', icone: Icons.home_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16), // Espaço entre os dois campos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _construirLabel('Complemento'),
                          _construirCampoTexto(dica: 'Ex: CASA A', icone: Icons.home_outlined),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- BOTÃO CRIAR PERFIL ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Tentou criar perfil!");
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

                // --- TEXTO DO RODAPÉ (LOGIN) ---
                GestureDetector(
                  onTap: () {
                    // Como a tela anterior geralmente é a de Login, o 'pop' apenas fecha a tela de cadastro e volta pra lá
                    Navigator.pop(context);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Já tem conta?\n'),
                        TextSpan(
                          text: 'Faça Login aqui!',
                          style: TextStyle(
                            color: AppColors.destaque,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.destaque,
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

  // --- "Receitas" ---
  
  Widget _construirLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
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

  Widget _construirCampoTexto({required String dica, required IconData icone, bool esSenha = false}) {
    return TextField(
      obscureText: esSenha ? _senhaOculta : false,
      style: const TextStyle(color: AppColors.principalEscura, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD2C3D9),
        hintText: dica,
        hintStyle: TextStyle(
          color: AppColors.principalEscura.withOpacity(0.5),
        ),
        prefixIcon: Icon(icone, color: AppColors.principalEscura, size: 20),
        suffixIcon: esSenha
            ? IconButton(
                icon: Icon(
                  _senhaOculta ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.principalEscura,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _senhaOculta = !_senhaOculta;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        // Diminui um pouco a altura do campo para caber melhor na tela de cadastro
        contentPadding: const EdgeInsets.symmetric(vertical: 14), 
      ),
    );
  }
}