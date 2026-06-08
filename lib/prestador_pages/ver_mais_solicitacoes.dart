import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/prestador_pages/visualizacao_proposta_prestador.dart';
import 'package:bicos_app/services/solicitacao_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class VerMaisSolicitacoesPage extends StatefulWidget {
  const VerMaisSolicitacoesPage({super.key});

  @override
  State<VerMaisSolicitacoesPage> createState() => _VerMaisSolicitacoesPageState();
}

class _VerMaisSolicitacoesPageState extends State<VerMaisSolicitacoesPage> {
  List<SolicitacaoResponse> _solicitacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarSolicitacoes();
  }

  Future<void> _carregarSolicitacoes() async {
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

  int get _novasCount =>
      _solicitacoes.where((s) => s.status == 'orcamento').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(showAvatar: true),
      ),
      body: Column(
        children: [
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
                if (_novasCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.destaque,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_novasCount novas',
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.destaque))
                : _solicitacoes.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma solicitação recebida',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.branco.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        children: _solicitacoes
                            .map((s) => _construirCardSolicitacao(s))
                            .toList(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _construirCardSolicitacao(SolicitacaoResponse s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
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
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.principalEscura.withOpacity(0.1),
                  child: Text(
                    s.clienteNome.isNotEmpty
                        ? s.clienteNome[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.principalEscura,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
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
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.principalEscura,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: s.status == 'orcamento'
                                  ? Colors.orange.withOpacity(0.15)
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
                                    : AppColors.principal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.descricao,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                        builder: (context) => VisualizacaoPropostaPage(solicitacao: s),
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
      ),
    );
  }
}
