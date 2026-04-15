import 'package:bicos_app/cliente_pages/chat_cliente.dart';
import 'package:bicos_app/prestador_pages/chat_prestador.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

// Modelo de serviço
class Servico {
  final String nome;
  final String descricao;
  final String data;
  final String status; // 'em_andamento' ou 'finalizado'
  final String imagemAsset;

  const Servico({
    required this.nome,
    required this.descricao,
    required this.data,
    required this.status,
    required this.imagemAsset,
  });
}

class HistoricoServicos extends StatelessWidget {
  const HistoricoServicos({super.key});

  // Dados de exemplo baseados no protótipo
  static const List<Servico> _servicos = [
    Servico(
      nome: 'Roberto Josefino',
      descricao: 'Ajuste de encanamento',
      data: '07/04/2026',
      status: 'em_andamento',
      imagemAsset:
          'assets/eletricista.png',
    ),
    Servico(
      nome: 'Pedreiro',
      descricao: 'Levante de paredes',
      data: '19/02/2026',
      status: 'finalizado',
      imagemAsset:
          'assets/pedreiro.png', 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: [
              // ── HEADER ──
              Stack(
                children: [
                  Image.asset(
                    'assets/header.png',
                    fit: BoxFit.fill,
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/bicos_logo2.png', height: 40),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.destaque,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/perfil.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── CONTEÚDO SCROLLÁVEL ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Botão voltar
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.branco,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Histórico de serviços',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.branco,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._servicos.map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _construirCardServico(s, context),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _construirItemNav({
    required IconData icone,
    required String label,
    required bool ativo,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: ativo ? 16 : 8, vertical: 8),
      decoration: BoxDecoration(

        color: ativo ? AppColors.destaque : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icone,
 
            color: ativo
                ? AppColors.principalEscura
                : AppColors.branco.withOpacity(0.8),
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: ativo
                  ? AppColors.principalEscura
                  : AppColors.branco.withOpacity(0.8),
              fontSize: 10,
              fontWeight: ativo ? FontWeight.w800 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCardServico(Servico servico, BuildContext context) {
    final bool emAndamento = servico.status == 'em_andamento';
    final Color corStatus = emAndamento
        ? const Color(0xFFFFA726)
        : const Color(0xFF4CAF50);
    final String textoStatus = emAndamento ? 'Em andamento' : 'Finalizado';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar do prestador
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              servico.imagemAsset,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Informações do serviço
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome + status na mesma linha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        servico.nome,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.principalEscura,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(top: 3, right: 4),
                          decoration: BoxDecoration(
                            color: corStatus,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          textoStatus,
                          style: GoogleFonts.plusJakartaSans(
                            color: corStatus,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // Descrição
                Text(
                  servico.descricao,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.principalEscura.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 2),

                // Data
                Text(
                  servico.data,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.principalEscura.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 10),

                // Botão Visualizar
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatClientePage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.principal, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Visualizar',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.principal,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
