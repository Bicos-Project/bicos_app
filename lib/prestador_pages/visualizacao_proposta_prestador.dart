import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/core/app_colors.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/prestador_pages/chat_prestador.dart';
import 'package:flutter/material.dart';

class VisualizacaoPropostaPage extends StatelessWidget {
  final SolicitacaoResponse solicitacao;

  const VisualizacaoPropostaPage({super.key, required this.solicitacao});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.principal,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: const AppHeader(showAvatar: true),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.branco,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitacao.anuncioTitulo ?? 'Serviço',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CLIENTE',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cinza,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solicitacao.clienteNome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'DESCRIÇÃO',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cinza,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cinza.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        solicitacao.descricao,
                        style: const TextStyle(color: AppColors.cinza),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cinza,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: solicitacao.status == 'orcamento'
                            ? Colors.orange.withOpacity(0.15)
                            : AppColors.destaque.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        solicitacao.status.replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: solicitacao.status == 'orcamento'
                              ? Colors.orange
                              : AppColors.principal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'AGENDAMENTO',
                content: solicitacao.dataSolicitacao ?? 'A combinar',
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                title: 'SOLICITAÇÃO',
                content: '#${solicitacao.id}',
                icon: Icons.receipt_long_outlined,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatVendedor(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.destaque,
                    foregroundColor: const Color(0xFF425F23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fazer orçamento',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.branco.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.branco, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(icon, color: AppColors.destaque, size: 24),
        ],
      ),
    );
  }
}
