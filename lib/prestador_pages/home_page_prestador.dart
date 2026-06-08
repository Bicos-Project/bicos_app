import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/core/app_colors.dart';
import 'package:bicos_app/models/media_avaliacao.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/prestador_pages/andamento_servico.dart';
import 'package:bicos_app/prestador_pages/minhas_avaliacoes.dart';
import 'package:bicos_app/prestador_pages/visualizacao_proposta_prestador.dart';
import 'package:bicos_app/services/avaliacao_service.dart';
import 'package:bicos_app/services/solicitacao_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:bicos_app/prestador_pages/ver_mais_solicitacoes.dart';

class HomePagePrestador extends StatefulWidget {
  const HomePagePrestador({super.key, required this.title});
  final String title;

  @override
  HomePagePrestadorState createState() => HomePagePrestadorState();
}

class HomePagePrestadorState extends State<HomePagePrestador> {
  List<SolicitacaoResponse> _solicitacoes = [];
  bool _isLoading = true;
  String? _erro;
  int? _prestadorId;
  MediaAvaliacao? _media;

  @override
  void initState() {
    super.initState();
    _carregarSolicitacoes();
  }

  Future<void> reloadData() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });
    await _carregarSolicitacoes();
  }

  Future<void> _carregarSolicitacoes() async {
    final userData = await AuthStorage.getUserData();
    _prestadorId = userData['id'] as int?;

    if (_prestadorId == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _erro = 'ID do prestador não encontrado. Faça login novamente.';
        });
      }
      return;
    }

    try {
      final list = await SolicitacaoService.listarPorPrestador(_prestadorId!);
      if (mounted) setState(() => _solicitacoes = list);
    } catch (e) {
      if (mounted) {
        setState(() => _erro = 'Erro ao carregar solicitações: $e');
      }
    }

    try {
      final media = await AvaliacaoService.buscarMedia(_prestadorId!);
      if (mounted) setState(() => _media = media);
    } catch (_) {
      // rating indisponível
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _novasCount =>
      _solicitacoes.where((s) => s.status == 'orcamento').length;

  List<SolicitacaoResponse> get _servicosEmAndamento =>
      _solicitacoes.where((s) => s.status == 'em_andamento' || s.status == 'esperando_pagamento').toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.principal,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: const AppHeader(showAvatar: true),
        ),
        body: RefreshIndicator(
          onRefresh: reloadData,
          color: AppColors.destaque,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Olá, Usuário!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Veja como andam os seus bicos.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (_prestadorId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Seu ID: $_prestadorId',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                _buildRatingCard(),
                const SizedBox(height: 32),
                _buildSectionTitle(
                  'Solicitações recebidas',
                  _isLoading ? '...' : '$_novasCount novas',
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: AppColors.destaque),
                    ),
                  )
                else if (_erro != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          _erro!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else if (_solicitacoes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Nenhuma solicitação recebida',
                      style: TextStyle(
                        color: AppColors.branco.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  ..._solicitacoes
                      .where((s) => s.status == 'orcamento')
                      .take(3)
                      .map((s) => _buildSolicitacaoCard(s)),
                if (_solicitacoes.where((s) => s.status == 'orcamento').length > 3)
                  _buildVerMaisSolicitacoesButton(),
                const SizedBox(height: 20),
                _buildSectionTitle(
                  'Serviços em andamento',
                  '${_servicosEmAndamento.length} em andamento',
                ),
                const SizedBox(height: 24),
                if (_servicosEmAndamento.isEmpty)
                  _buildEmptyEmAndamento()
                else
                  ..._servicosEmAndamento.map(_buildServicoAndamentoCard),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    final nota = _media != null ? _media!.mediaNotas.toStringAsFixed(1) : '—';
    final total = _media?.totalAvaliacoes ?? 0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MinhasAvaliacoesPage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF481),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars, color: Color(0xFF5C2B67), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'AVALIAÇÃO',
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  nota,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$total avaliação${total == 1 ? '' : 'ões'}',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF5C2B67)),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Color(0xFF5C2B67)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.destaque,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: const TextStyle(color: AppColors.cinza, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildSolicitacaoCard(SolicitacaoResponse s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                Text(
                  s.clienteNome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  s.anuncioTitulo ?? s.descricao,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VisualizacaoPropostaPage(solicitacao: s),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.branco,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text('Visualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerMaisSolicitacoesButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 95,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerMaisSolicitacoesPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.principal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: AppColors.destaque, width: 2),
            ),
          ),
          child: const Text(
            'Ver Mais',
            style: TextStyle(color: AppColors.destaque, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyEmAndamento() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Nenhum serviço em andamento',
        style: TextStyle(
          color: AppColors.branco.withOpacity(0.5),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildServicoAndamentoCard(SolicitacaoResponse s) {
    final progress = s.status == 'esperando_pagamento' ? 0.75 : 0.5;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AndamentoServicoPage(solicitacao: s),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.anuncioTitulo ?? s.descricao,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Cliente: ${s.clienteNome}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: const Color(0xFFDFF481),
            ),
          ],
        ),
      ),
    );
  }
}
