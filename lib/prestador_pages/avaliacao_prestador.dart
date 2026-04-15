import 'package:bicos_app/core/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
// import '../core/app_text_styles.dart'; // Removido o import duplicado

class AvaliacaoPrestadorPage extends StatefulWidget {
  const AvaliacaoPrestadorPage({super.key});

  @override
  State<AvaliacaoPrestadorPage> createState() => _AvaliacaoPrestadorPageState();
}

class _AvaliacaoPrestadorPageState extends State<AvaliacaoPrestadorPage> {
  // Estado para armazenar a nota (0 a 5)
  int _nota = 0;

  // Função auxiliar para lidar com erros de asset de forma segura
  Widget _exibirImagemSegura(String? caminho, IconData fallback, double tamanho) {
    if (caminho == null || caminho.isEmpty) {
      return Icon(fallback, color: AppColors.principal, size: tamanho);
    }
    return Image.asset(
      caminho,
      height: tamanho,
      width: tamanho,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallback, color: AppColors.principal, size: tamanho);
      },
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
                Container(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: Image.asset('assets/perfil.png', fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos o Scaffold para estruturar a página
    return Scaffold(
      backgroundColor: AppColors.principal, // Roxo/vinho de fundo do protótipo
      appBar: PreferredSize(preferredSize: const Size(double.infinity, 80), child: _construirHeader()),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                // --- CARD DE SERVIÇO FINALIZADO ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Ícone de check dentro do círculo neon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.destaque, // Fundo neon clarinho
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: AppColors.preto,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Título "Serviço finalizado!"
                      Text(
                        'Serviço finalizado!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.principalEscura, // Roxo do fundo
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Texto descritivo
                      Text(
                        'Você finalizou o serviço, realize uma avaliação ao cliente.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.principal.withOpacity(0.8),
                          height: 1.5, // Maior espaçamento entre linhas
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // --- SEÇÃO DE ESTRELAS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centraliza as estrelas
                  children: List.generate(5, (index) {
                    final int valorEstrela = index + 1;
                    return GestureDetector(
                      onTap: () {
                        // Ao tocar, atualiza a nota e refaz a tela
                        setState(() {
                          _nota = valorEstrela;
                        });
                        print("Nota selecionada: $_nota");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Icon(
                          _nota >= valorEstrela ? Icons.star : Icons.star_border,
                          // Amarelo se tiver nota, neon se não tiver
                          color: _nota >= valorEstrela
                              ? AppColors.destaque // Estrela amarela preenchida
                              : AppColors.destaque, // Estrela neon contornada
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 40),

                // --- CAMPO DE OBSERVAÇÕES ---
                Text(
                  'Descreva a sua experiência com Vera Azevedo:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Campo de texto multi-linha (text area)
                TextField(
                  maxLines: 6, // Define a altura visual
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.principalEscura, // Texto roxo escuro
                  ),
                  decoration: InputDecoration(
                    hintText: 'Escreva aqui suas observações...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.principal.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.branco, // Fundo branco
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Sem borda visível
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 48), // Espaço antes do botão

                // --- BOTÃO ENVIAR AVALIAÇÃO ---
                ElevatedButton(
                  onPressed: () {
                    // Lógica para enviar a avaliação (print para teste)
                    print("Avaliação enviada: Nota $_nota e texto do campo.");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avaliação enviada com sucesso!')),
                    );
                    Navigator.pop(context); // Volta após enviar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalEscura, // Roxo muito escuro do botão
                    foregroundColor: AppColors.branco, // Cor do texto
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Enviar avaliação',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24), // Espaço no final da página (para SafeArea)
              ],
            ),
          ),
        ),
      ),
    );
  }
}