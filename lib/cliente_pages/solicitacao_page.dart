import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../components/app_image.dart';
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
              _construirTopo(),
              _construirCardPrestador(),
              const SizedBox(height: 24),
              _construirLabel(Icons.description, 'DESCRIÇÃO DO SERVIÇO'),
              const SizedBox(height: 10),
              _construirCampoDescricao(),
              const SizedBox(height: 24),
              _construirLabel(Icons.calendar_today, 'DATA ESTIMADA'),
              const SizedBox(height: 10),
              _construirCampoData(),
              const SizedBox(height: 24),
              _construirLabel(Icons.attach_money, 'VALOR SUGERIDO (opcional)'),
              const SizedBox(height: 10),
              _construirCampoValor(),
              if (_error != null) _construirErro(),
              const SizedBox(height: 32),
              _construirBotao(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirTopo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.branco, size: 20),
          ),
          const SizedBox(width: 4),
          Text(
            'Solicitar Serviço',
            style: TextStyle(
              color: AppColors.branco.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCardPrestador() {
    final p = widget.prestador;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.branco.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.branco.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(
              p.imagemAsset,
              width: 52,
              height: 52,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.nome,
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.destaque.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p.especialidade,
                    style: const TextStyle(
                      color: AppColors.destaque,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.branco.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _construirLabel(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: AppColors.destaque, size: 18),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              color: AppColors.branco.withOpacity(0.85),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCampoDescricao() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.branco.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.branco.withOpacity(0.08)),
        ),
        child: TextField(
          controller: _descricaoController,
          maxLines: 6,
          style: const TextStyle(color: AppColors.branco, height: 1.5),
          decoration: InputDecoration(
            hintText: "O que você precisa? Descreva o trabalho com detalhes...",
            hintStyle: TextStyle(
              color: AppColors.branco.withOpacity(0.3),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.all(16),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _construirCampoData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: _escolherData,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.branco.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.branco.withOpacity(0.08)),
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
                      ? AppColors.branco
                      : AppColors.branco.withOpacity(0.3),
                  fontSize: 15,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: AppColors.destaque, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCampoValor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.branco.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.branco.withOpacity(0.08)),
        ),
        child: TextField(
          controller: _valorController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.branco, fontSize: 16),
          decoration: InputDecoration(
            prefixText: 'R\$  ',
            prefixStyle: TextStyle(
              color: AppColors.destaque,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            hintText: "0,00",
            hintStyle: TextStyle(
              color: AppColors.branco.withOpacity(0.3),
              fontSize: 16,
            ),
            contentPadding: const EdgeInsets.all(16),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _construirErro() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirBotao() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _enviarSolicitacao,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.destaque,
            elevation: 4,
            shadowColor: AppColors.destaque.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.principalEscura,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, color: AppColors.principalEscura, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Pedir Orçamento',
                      style: TextStyle(
                        color: AppColors.principalEscura,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
