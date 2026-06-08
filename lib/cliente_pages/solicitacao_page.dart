import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/app_header.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../providers/auth_provider.dart';
import '../services/anuncio_service.dart';
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
  bool _isLoading = false;
  bool _anuncioLoading = true;
  String? _error;
  int? _anuncioId;

  @override
  void initState() {
    super.initState();
    _carregarAnuncio();
  }

  Future<void> _carregarAnuncio() async {
    final prestadorId = widget.prestador.id;
    if (prestadorId == null) {
      setState(() => _anuncioLoading = false);
      return;
    }
    try {
      final anuncios = await AnuncioService.listarPorPrestador(prestadorId);
      if (anuncios.isNotEmpty && mounted) {
        setState(() => _anuncioId = anuncios.first.id);
      } else if (mounted) {
        setState(() => _error = 'Este prestador ainda não possui anúncio disponível.');
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _anuncioLoading = false);
    }
  }

  Future<void> _enviarSolicitacao() async {
    if (_descricaoController.text.trim().isEmpty) {
      setState(() => _error = 'Descreva o serviço que precisa.');
      return;
    }
    if (_anuncioId == null) {
      setState(() => _error = 'Prestador não possui anúncio disponível.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      final solicitacao = await SolicitacaoService.criar(
        clienteId: auth.userId!,
        anuncioId: _anuncioId!,
        descricao: _descricaoController.text.trim(),
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
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
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
                      onPressed: _isLoading || _anuncioLoading ? null : _enviarSolicitacao,
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
                        : Text(
                            _anuncioId == null && !_anuncioLoading
                                ? 'Indisponível'
                                : 'Pedir Orçamento',
                            style: const TextStyle(
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
