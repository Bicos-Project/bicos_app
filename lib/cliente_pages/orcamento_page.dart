import 'package:flutter/material.dart';
import '../components/app_header.dart';
import '../components/app_image.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../models/solicitacao_response.dart';
import '../services/solicitacao_service.dart';
import 'andamento_servico_cliente.dart';
import 'chat_cliente.dart';

class OrcamentoPage extends StatefulWidget {
  final SolicitacaoResponse solicitacao;
  final Prestador prestador;

  const OrcamentoPage({
    super.key,
    required this.solicitacao,
    required this.prestador,
  });

  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  late SolicitacaoResponse _solicitacao;
  bool _cancelando = false;

  @override
  void initState() {
    super.initState();
    _solicitacao = widget.solicitacao;
  }

  String get _tituloStatus {
    switch (_solicitacao.status) {
      case 'orcamento':
        return '📋 Solicitação Enviada';
      case 'em_andamento':
        return '🔧 Serviço em Andamento';
      case 'esperando_pagamento':
        return '💳 Aguardando Pagamento';
      case 'finalizado':
        return '✅ Serviço Finalizado';
      case 'cancelado':
        return '❌ Solicitação Cancelada';
      default:
        return '📋 Solicitação';
    }
  }

  int get _stepAtual {
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
        return -1;
    }
  }

  bool get _isCancelado => _solicitacao.status == 'cancelado';

  Future<void> _cancelar() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar solicitação?'),
        content: const Text(
            'Tem certeza que deseja cancelar esta solicitação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _cancelando = true);
    try {
      await SolicitacaoService.cancelar(_solicitacao.id);
      if (!mounted) return;
        setState(() {
        _solicitacao = SolicitacaoResponse(
          id: _solicitacao.id,
          descricao: _solicitacao.descricao,
          status: 'cancelado',
          clienteId: _solicitacao.clienteId,
          clienteNome: _solicitacao.clienteNome,
          prestadorId: _solicitacao.prestadorId,
          prestadorNome: _solicitacao.prestadorNome,
          clienteAvaliacao: _solicitacao.clienteAvaliacao,
        );
        _cancelando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação cancelada')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _cancelando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cancelar solicitação')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagem = widget.prestador.fotosUrls.isNotEmpty
        ? widget.prestador.fotosUrls.first
        : widget.prestador.imagemAsset;

    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(showBack: true, centerTitle: true, title: 'Solicitação'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 4),
                child: Text(
                  _tituloStatus,
                  style: TextStyle(
                    color: _isCancelado
                        ? Colors.red.shade300
                        : AppColors.branco,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.branco,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: AppImage(imagem),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.prestador.nome,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.prestador.especialidade,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isCancelado
                              ? Colors.red.shade50
                              : AppColors.destaque.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _solicitacao.status,
                          style: TextStyle(
                            color: _isCancelado
                                ? Colors.red.shade700
                                : AppColors.principal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isCancelado) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.principalEscura.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Descrição do serviço",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _solicitacao.descricao,
                          style: const TextStyle(
                            color: AppColors.branco,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_solicitacao.dataEstimada != null ||
                    _solicitacao.valorSugerido != null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.principalEscura.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_solicitacao.dataEstimada != null) ...[
                            const Text(
                              "Data estimada",
                              style: TextStyle(
                                color: AppColors.branco,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _solicitacao.dataEstimada!,
                              style: const TextStyle(
                                color: AppColors.branco,
                                fontSize: 16,
                              ),
                            ),
                          ],
                          if (_solicitacao.valorSugerido != null &&
                              _solicitacao.dataEstimada != null)
                            const SizedBox(height: 12),
                          if (_solicitacao.valorSugerido != null) ...[
                            const Text(
                              "Valor sugerido",
                              style: TextStyle(
                                color: AppColors.branco,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'R\$ ${_solicitacao.valorSugerido!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.branco,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                _construirTimeline(),
                const SizedBox(height: 24),
              ],
              if (_isCancelado) ...[
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red.shade400),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Esta solicitação foi cancelada e não está mais ativa.',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.branco,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(
                              color: AppColors.preto.withOpacity(0.6),
                            ),
                          ),
                          const Text("A definir"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Taxa Bicos",
                            style: TextStyle(
                              color: AppColors.preto.withOpacity(0.6),
                            ),
                          ),
                          const Text("A definir"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: AppColors.preto.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total à pagar",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "A definir",
                            style: TextStyle(
                              color: AppColors.principal,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isCancelado) ...[
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatClientePage(solicitacao: _solicitacao),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Conversar com prestador'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.destaque,
                      foregroundColor: const Color(0xFF425F23),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (_solicitacao.status == 'em_andamento' ||
                    _solicitacao.status == 'esperando_pagamento' ||
                    _solicitacao.status == 'finalizado') ...[
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AndamentoServicoClientePage(
                                solicitacao: _solicitacao),
                          ),
                        );
                      },
                      icon:
                          const Icon(Icons.track_changes_outlined, size: 18),
                      label: const Text('Acompanhar serviço'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.branco,
                        foregroundColor: AppColors.principal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
              if (_solicitacao.status == 'orcamento') ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: _cancelando ? null : _cancelar,
                    icon: _cancelando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white70,
                            ),
                          )
                        : const Icon(Icons.cancel_outlined,
                            color: Colors.white70, size: 18),
                    label: Text(
                      _cancelando ? 'Cancelando...' : 'Cancelar solicitação',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "ID da solicitação: #${_solicitacao.id}",
                  style: TextStyle(
                    color: AppColors.branco.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirTimeline() {
    final stepAtual = _stepAtual;
    final labels = ["Orçamento", "Em andamento", "Pagamento", "Finalizado"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: AppColors.branco.withOpacity(0.2),
                ),
              ),
              Positioned(
                left: 0,
                right: (3 - stepAtual) / 4 * MediaQuery.of(context).size.width,
                child: Container(
                  height: 2,
                  color: AppColors.destaque,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  final isActive = index <= stepAtual;
                  final isCurrent = index == stepAtual;
                  return Container(
                    width: isCurrent ? 22 : 18,
                    height: isCurrent ? 22 : 18,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.destaque
                          : AppColors.branco.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(
                              color: AppColors.branco, width: 2)
                          : null,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              final isActive = index <= stepAtual;
              return Text(
                labels[index],
                style: TextStyle(
                  color: isActive
                      ? AppColors.destaque
                      : AppColors.branco.withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}