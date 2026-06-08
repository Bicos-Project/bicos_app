import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../components/app_header.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../providers/auth_provider.dart';
import '../services/solicitacao_service.dart';
import 'orcamento_page.dart';

class SolicitacaoPage extends StatefulWidget {
  final Prestador prestador;

  const SolicitacaoPage({super.key, required this.prestador});

  @override
  State<SolicitacaoPage> createState() => _SolicitacaoPageState();
}

class _SolicitacaoPageState extends State<SolicitacaoPage> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime? _dataEstimada;
  final _dataFormatador = DateFormat('dd/MM/yyyy');
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataEstimada ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.destaque,
              onPrimary: AppColors.principalEscura,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dataEstimada = picked);
    }
  }

  Future<void> _enviarSolicitacao() async {
    if (_descricaoController.text.trim().isEmpty) {
      setState(() => _error = 'Descreva o serviço que precisa.');
      return;
    }
    if (widget.prestador.id == null) {
      setState(() => _error = 'Prestador inválido.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      final valor = double.tryParse(
          _valorController.text.trim().replaceAll(',', '.'));
      final solicitacao = await SolicitacaoService.criar(
        clienteId: auth.userId!,
        prestadorId: widget.prestador.id!,
        descricao: _descricaoController.text.trim(),
        dataEstimada: _dataEstimada,
        valorSugerido: valor,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrcamentoPage(
            solicitacao: solicitacao,
            prestador: widget.prestador,
          ),
        ),
      );
    } catch (e) {
      setState(() => _error = 'Erro ao enviar solicitação. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'Solicitar Serviço',
                centerTitle: true,
              ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Solicitar para ${widget.prestador.nome}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Preencha os detalhes abaixo para o prestador saber o que você precisa.",
                    style: TextStyle(
                      color: AppColors.branco.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "DESCRIÇÃO DO SERVIÇO",
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.branco.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _descricaoController,
                      maxLines: 5,
                      style: const TextStyle(color: AppColors.preto),
                      decoration: const InputDecoration(
                        hintText: "O que você precisa hoje? Descreva o trabalho...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "DATA ESTIMADA",
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _escolherData,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.branco.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dataEstimada != null
                                ? _dataFormatador.format(_dataEstimada!)
                                : 'Selecionar data...',
                            style: TextStyle(
                              color: _dataEstimada != null
                                  ? AppColors.preto
                                  : AppColors.preto.withOpacity(0.4),
                              fontSize: 15,
                            ),
                          ),
                          const Icon(Icons.calendar_today,
                              color: AppColors.principal, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "VALOR SUGERIDO (opcional)",
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.branco.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _valorController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: AppColors.preto),
                      decoration: const InputDecoration(
                        prefixText: 'R\$ ',
                        prefixStyle: TextStyle(color: AppColors.preto),
                        hintText: "Ex: 150,00",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _enviarSolicitacao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.destaque,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.preto,
                            ),
                          )
                        : const Text(
                            'Pedir Orçamento',
                            style: TextStyle(
                              color: AppColors.preto,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
}