import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/prestador_pages/chat_prestador.dart';
import 'package:bicos_app/services/solicitacao_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import '../components/app_header.dart';
import '../core/app_colors.dart';
import '../core/status_helper.dart';

class VisualizacaoChats extends StatefulWidget {
  const VisualizacaoChats({super.key});

  @override
  State<VisualizacaoChats> createState() => _VisualizacaoChatsState();
}

class _VisualizacaoChatsState extends State<VisualizacaoChats> {
  List<SolicitacaoResponse> _solicitacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final userData = await AuthStorage.getUserData();
    final prestadorId = userData['id'] as int?;
    if (prestadorId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final list = await SolicitacaoService.listarPorPrestador(prestadorId);
      if (mounted) setState(() => _solicitacoes = list);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(showAvatar: true),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.destaque))
              : _solicitacoes.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma conversa',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      children: _solicitacoes
                          .map((s) => _buildChatCard(s))
                          .toList(),
                    ),
        ),
      ],
    );
  }

  Widget _buildChatCard(SolicitacaoResponse s) {
    final statusLabel = StatusHelper.format(s.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatVendedor(solicitacao: s),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.branco.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.branco.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.branco.withOpacity(0.2),
                child: Text(
                  s.clienteNome.isNotEmpty
                      ? s.clienteNome[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.clienteNome,
                      style: const TextStyle(
                        color: AppColors.branco,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.descricao,
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: s.status == 'orcamento'
                      ? Colors.orange.withOpacity(0.2)
                      : s.status == 'finalizado'
                          ? Colors.green.withOpacity(0.2)
                          : AppColors.destaque.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: s.status == 'orcamento'
                        ? Colors.orange
                        : s.status == 'finalizado'
                            ? Colors.green
                            : AppColors.destaque,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
