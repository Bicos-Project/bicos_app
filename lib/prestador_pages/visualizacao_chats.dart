import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/app_header.dart';
import '../core/app_colors.dart';

class VisualizacaoChats extends StatelessWidget {
  const VisualizacaoChats({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados baseados no seu protótipo do Figma
    final List<Map<String, String>> conversas = [
      {
        "nome": "Vera Azevedo",
        "mensagem": "Combinado! Aguardo você.",
        "data": "06/04/2026",
        "foto": "assets/perfil1.png", 
      },
      {
        "nome": "Clarisse",
        "mensagem": "Pagamento realizado!",
        "data": "21/03/2026",
        "foto": "assets/perfil2.png",
      },
      {
        "nome": "Juliana Souza",
        "mensagem": "Adorei o serviço!",
        "data": "05/02/2026",
        "foto": "assets/perfil3.png",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(showAvatar: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversas recentes',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.branco,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Lista de conversas
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: conversas.length,
                  itemBuilder: (context, index) {
                    return _buildChatCard(conversas[index]);
                  },
                ),
                const SizedBox(
                  height: 100,
                ), // Espaço para a Bottom Navigation Bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatCard(Map<String, String> conversa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Roxo translúcido para dar profundidade sobre o gradiente
        color: AppColors.branco.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.branco.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Foto de Perfil
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 50,
              height: 50,
              color: AppColors.branco.withOpacity(0.2),
              child: Image.asset(
                conversa['foto']!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: AppColors.branco),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Nome e Mensagem
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversa['nome']!,
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  conversa['mensagem']!,
                  style: TextStyle(
                    color: AppColors.branco.withOpacity(0.7),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Data
          Text(
            conversa['data']!,
            style: TextStyle(
              color: AppColors.branco.withOpacity(0.4),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
