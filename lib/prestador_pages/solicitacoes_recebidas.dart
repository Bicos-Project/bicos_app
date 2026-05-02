import 'package:bicos_app/prestador_pages/visualizacao_proposta_prestador.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class SolicitacoesRecebidas extends StatelessWidget {
  const SolicitacoesRecebidas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,

      // --- SEU HEADER AQUI ---
      appBar: _construirHeader(),

      // --- RESTO DA TELA NO BODY ---
      body: Column(
        children: [
          const SizedBox(height: 24),

          // --- TÍTULO E BADGE "NOVAS" ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Solicitações recebidas',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.branco,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.destaque,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '3 novas',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.principalEscura,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- LISTA DE SOLICITAÇÕES ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                _construirCardSolicitacao(
                  context: context,
                  nome: 'Vera Azevedo',
                  servico: 'Ajuste de chuveiro',
                  horario: 'Amanhã às 09:00',
                  tempoPostagem: 'Há 5 min',
                  foto: 'assets/vera.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- O MÉTODO COM O SEU CÓDIGO DE HEADER ---
  PreferredSizeWidget _construirHeader() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Stack(
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
      ),
    );
  }

  Widget _construirCardSolicitacao({
    required BuildContext context,
    required String nome,
    required String servico,
    required String horario,
    required String tempoPostagem,
    required String foto,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  foto,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                    child: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nome,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.principalEscura,
                          ),
                        ),
                        Text(
                          tempoPostagem,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$servico • 4h • $horario',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 120,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisualizacaoPropostaPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.principal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Visualizar',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.principal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
