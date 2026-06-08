import 'package:bicos_app/cliente_pages/avaliacao.dart';
import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/services/solicitacao_service.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AndamentoServicoClientePage extends StatefulWidget {
  final SolicitacaoResponse solicitacao;

  const AndamentoServicoClientePage({
    super.key,
    required this.solicitacao,
  });

  @override
  State<AndamentoServicoClientePage> createState() =>
      _AndamentoServicoClientePageState();
}

class _AndamentoServicoClientePageState
    extends State<AndamentoServicoClientePage> {
  late SolicitacaoResponse _solicitacao;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _solicitacao = widget.solicitacao;
  }

  int get _etapaAtual {
    switch (_solicitacao.status) {
      case 'orcamento':
        return 0;
      case 'em_andamento':
        return 1;
      case 'esperando_pagamento':
        return 2;
      case 'finalizado':
        return 3;
      default:
        return 0;
    }
  }

  Future<void> _confirmarPagamento() async {
    setState(() => _isLoading = true);
    try {
      final updated = await SolicitacaoService.confirmarPagamento(
          _solicitacao.id, 'CLIENTE');
      if (mounted) {
        setState(() => _solicitacao = updated);
        if (updated.status == 'finalizado') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AvaliacaoServico(solicitacao: updated),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao confirmar pagamento')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(showAvatar: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrestadorCard(),
            const SizedBox(height: 16),
            _buildProgressoServico(),
            const SizedBox(height: 16),
            _buildAcoes(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrestadorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.principalEscura.withOpacity(0.1),
            child: Text(
              _solicitacao.prestadorNome.isNotEmpty
                  ? _solicitacao.prestadorNome[0].toUpperCase()
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
                  _solicitacao.prestadorNome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.preto,
                  ),
                ),
                Text(
                  _solicitacao.descricao,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '#${_solicitacao.id}',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _solicitacao.status == 'em_andamento'
                  ? Colors.orange.withOpacity(0.15)
                  : AppColors.destaque.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _solicitacao.status.replaceAll('_', ' '),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _solicitacao.status == 'em_andamento'
                    ? Colors.orange
                    : AppColors.principal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressoServico() {
    const etapas = [
      'Orçamento',
      'Em andamento',
      'Esperando\npagamento',
      'Finalizado',
    ];
    final etapaAtual = _etapaAtual;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(etapas.length, (i) {
              if (i == 0 || i == 2) return const Expanded(child: SizedBox());
              return Expanded(
                child: Text(
                  etapas[i],
                  textAlign: i == 1 ? TextAlign.center : TextAlign.right,
                  style: TextStyle(
                    fontSize: 10,
                    color: i <= etapaAtual ? AppColors.principal : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(etapas.length * 2 - 1, (i) {
              if (i.isOdd) {
                final segmentoAtivo = (i ~/ 2) < etapaAtual;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: segmentoAtivo
                        ? AppColors.principal
                        : Colors.grey.shade300,
                  ),
                );
              } else {
                final etapaIndex = i ~/ 2;
                final ativo = etapaIndex <= etapaAtual;
                return Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ativo ? AppColors.principal : Colors.grey.shade300,
                    border: Border.all(
                      color: ativo ? AppColors.principal : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(etapas.length, (i) {
              if (i == 1 || i == 3) return const Expanded(child: SizedBox());
              return Expanded(
                child: Text(
                  etapas[i],
                  textAlign: i == 0 ? TextAlign.left : TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAcoes() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.destaque),
      );
    }

    if (_solicitacao.status == 'esperando_pagamento') {
      final confirmacoes = [
        if (_solicitacao.prestadorConfirmouPagamento) 1,
        if (_solicitacao.clienteConfirmouPagamento) 1,
      ].length;
      final jaConfirmou = _solicitacao.clienteConfirmouPagamento;

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.branco,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.destaque.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        jaConfirmou
                            ? Icons.check_circle
                            : Icons.payments_outlined,
                        color: jaConfirmou
                            ? Colors.green
                            : AppColors.principalEscura,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jaConfirmou
                                ? 'Pagamento confirmado por você'
                                : 'Aguardando sua confirmação',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.preto,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            jaConfirmou
                                ? 'Aguardando ${_solicitacao.prestadorNome}'
                                : 'Você confirma o pagamento?',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.preto.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: confirmacoes == 2
                            ? Colors.green.withOpacity(0.15)
                            : AppColors.destaque.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$confirmacoes/2',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: confirmacoes == 2
                              ? Colors.green
                              : AppColors.principalEscura,
                        ),
                      ),
                    ),
                  ],
                ),
                if (confirmacoes == 1) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.principalEscura.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 16,
                            color: AppColors.principalEscura.withOpacity(0.6)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Aguardando confirmação de ${_solicitacao.prestadorNome} para finalizar',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.principalEscura.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!jaConfirmou) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmarPagamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.destaque,
                  foregroundColor: AppColors.principalEscura,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirmar pagamento',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      );
    }

    if (_solicitacao.status == 'em_andamento') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.branco.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.destaque, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Aguardando o prestador finalizar o serviço',
                style: TextStyle(color: AppColors.branco, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    if (_solicitacao.status == 'finalizado') {
      if (_solicitacao.clienteAvaliou) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.branco,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Você já avaliou este prestador',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.preto,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AvaliacaoServico(solicitacao: _solicitacao),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.destaque,
            foregroundColor: AppColors.principalEscura,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: const Text(
            'Avaliar prestador',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
