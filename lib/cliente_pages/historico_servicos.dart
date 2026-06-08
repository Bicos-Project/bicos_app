import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/app_header.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../models/solicitacao_response.dart';
import '../providers/auth_provider.dart';
import '../services/solicitacao_service.dart';
import 'andamento_servico_cliente.dart';
import 'orcamento_page.dart';

class HistoricoServicos extends StatefulWidget {
  const HistoricoServicos({super.key});

  @override
  HistoricoServicosState createState() => HistoricoServicosState();
}

class HistoricoServicosState extends State<HistoricoServicos> {
  List<SolicitacaoResponse> _solicitacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarSolicitacoes();
  }

  Future<void> reloadData() async {
    setState(() => _isLoading = true);
    await _carregarSolicitacoes();
  }

  Future<void> _carregarSolicitacoes() async {
    final auth = context.read<AuthProvider>();
    final clienteId = auth.userId;
    if (clienteId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final list = await SolicitacaoService.listarPorCliente(clienteId);
      if (mounted) setState(() => _solicitacoes = list);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              trailing: Row(
                children: [
                  const Icon(Icons.history, color: AppColors.destaque, size: 22),
                  const SizedBox(width: 8),
                  Text('Histórico', style: GoogleFonts.plusJakartaSans(color: AppColors.branco, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.destaque))
                  : _solicitacoes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: AppColors.branco.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum serviço solicitado ainda',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.branco.withOpacity(0.5),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Quando você solicitar um serviço,\nele aparecerá aqui',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.branco.withOpacity(0.3),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _carregarSolicitacoes,
                          color: AppColors.destaque,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: _solicitacoes
                                .map((s) => _buildSolicitacaoCard(s))
                                .toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolicitacaoCard(SolicitacaoResponse s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (s.status == 'em_andamento' ||
              s.status == 'esperando_pagamento' ||
              s.status == 'finalizado') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AndamentoServicoClientePage(solicitacao: s),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrcamentoPage(
                  solicitacao: s,
                  prestador: Prestador(
                    id: s.prestadorId,
                    nome: s.prestadorNome,
                    especialidade: s.anuncioTitulo ?? '',
                    descricao: s.descricao,
                    imagemAsset: '',
                    avaliacao: 0,
                    distancia: '',
                    categoria: '',
                  ),
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.branco,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.principalEscura.withOpacity(0.1),
                child: Text(
                  s.prestadorNome.isNotEmpty
                      ? s.prestadorNome[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.principalEscura,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.prestadorNome,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.principalEscura,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.anuncioTitulo ?? s.descricao,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: s.status == 'orcamento'
                      ? Colors.orange.withOpacity(0.15)
                      : s.status == 'finalizado'
                          ? Colors.green.withOpacity(0.15)
                          : AppColors.destaque.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s.status.replaceAll('_', ' '),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: s.status == 'orcamento'
                        ? Colors.orange
                        : s.status == 'finalizado'
                            ? Colors.green
                            : AppColors.principal,
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
