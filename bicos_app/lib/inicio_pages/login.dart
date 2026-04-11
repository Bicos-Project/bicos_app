import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'cadastro.dart';

// Agora usamos StatefulWidget porque a tela precisa "reagir" ao clique no olho da senha
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Variável que controla se a senha está escondida ou não
  bool _senhaOculta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Center(
          // SingleChildScrollView é essencial em telas de login para o teclado do celular não cobrir os botões!
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- A LOGO ---
                Image.asset(
                  'assets/bicos_logo1.png',
                  height: 80,
                ),
                const SizedBox(height: 24),

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
                      const TextSpan(text: 'Bem vindo de volta\nao '),
                      TextSpan(
                        text: 'Bicos',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic, // Deixei itálico igualzinho ao seu Figma!
                        ),
                      ),
                      const TextSpan(text: '!'),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // --- CAMPO DE E-MAIL ---
                _construirLabel('E-mail'),
                const SizedBox(height: 8),
                _construirCampoTexto(
                  dica: 'Digite seu e-mail',
                  icone: Icons.alternate_email,
                ),

                const SizedBox(height: 24),

                // --- CAMPO DE SENHA ---
                _construirLabel('Senha'),
                const SizedBox(height: 8),
                _construirCampoTexto(
                  dica: '••••••••••••',
                  icone: Icons.lock_outline,
                  esSenha: true,
                ),

                const SizedBox(height: 32),

                // --- BOTÃO DE ENTRAR ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Tentou fazer login!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3A70), // O roxo mais escurinho do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // --- TEXTO DO RODAPÉ (CADASTRAR) ---
                GestureDetector(
                  onTap: () {
                    // NAVEGANDO PARA O CADASTRO!
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Cadastro()),
                    );
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
                        const TextSpan(text: 'Não possui conta?\n'),
                        TextSpan(
                          text: 'Cadastre-se aqui!',
                          style: TextStyle(
                            color: AppColors.destaque,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline, // Linha embaixo do texto
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

  // --- Nossas "Receitas" para deixar o código limpo ---

  // Receita para os títulos acima dos campos
  Widget _construirLabel(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        texto,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.branco,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Receita para os campos de digitar (Inputs)
  Widget _construirCampoTexto({required String dica, required IconData icone, bool esSenha = false}) {
    return TextField(
      obscureText: esSenha ? _senhaOculta : false, // Aqui a mágica de esconder a senha acontece!
      style: const TextStyle(color: AppColors.principalEscura),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD2C3D9), // A cor lilás dos campos
        hintText: dica,
        hintStyle: TextStyle(
          color: AppColors.principalEscura.withOpacity(0.5),
        ),
        prefixIcon: Icon(icone, color: AppColors.principalEscura),
        // Se for campo de senha, adiciona o botão do olhinho!
        suffixIcon: esSenha
            ? IconButton(
                icon: Icon(
                  _senhaOculta ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.principalEscura,
                ),
                onPressed: () {
                  // O setState avisa a tela que ela precisa se desenhar de novo porque a variável mudou
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
      ),
    );
  }
}