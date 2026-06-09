import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/services/solicitacao_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/status_helper.dart';

class HistoricoServicoRealizadoPage extends StatefulWidget {
  const HistoricoServicoRealizadoPage({super.key});

  @override
  State<HistoricoServicoRealizadoPage> createState() =>
      _HistoricoServicoRealizadoPageState();
}

class _HistoricoServicoRealizadoPageState
    extends State<HistoricoServicoRealizadoPage> {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(showAvatar: true),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.destaque))
          : _solicitacoes.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum serviço realizado ainda',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.branco.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  children: _solicitacoes
                      .map((s) => _buildHistoricoCard(s))
                      .toList(),
                ),
    );
  }

  Widget _buildHistoricoCard(SolicitacaoResponse s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.principalEscura.withOpacity(0.1),
                child: Text(
                  s.clienteNome.isNotEmpty
                      ? s.clienteNome[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.principalEscura,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                          s.clienteNome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.principalEscura,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: s.status == 'orcamento'
                                    ? Colors.orange
                                    : s.status == 'finalizado'
                                        ? Colors.green
                                        : Colors.orangeAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              StatusHelper.format(s.status),
                              style: TextStyle(
                                color: s.status == 'orcamento'
                                    ? Colors.orange
                                    : s.status == 'finalizado'
                                        ? Colors.green
                                        : Colors.orangeAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.descricao,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    if (s.dataSolicitacao != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        s.dataSolicitacao!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (s.dataEstimada != null ||
                        s.valorSugerido != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (s.dataEstimada != null) ...[
                            Icon(Icons.calendar_month,
                                size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 3),
                            Text(
                              s.dataEstimada!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                          if (s.dataEstimada != null &&
                              s.valorSugerido != null)
                            const SizedBox(width: 12),
                          if (s.valorSugerido != null) ...[
                            Icon(Icons.attach_money,
                                size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 3),
                            Text(
                              'R\$ ${s.valorSugerido!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
