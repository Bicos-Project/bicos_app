import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/services/avaliacao_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/app_header.dart';
import '../shared_pages/servico_concluido.dart';
import '../core/app_colors.dart';

class AvaliacaoPrestadorPage extends StatefulWidget {
  final SolicitacaoResponse solicitacao;

  const AvaliacaoPrestadorPage({super.key, required this.solicitacao});

  @override
  State<AvaliacaoPrestadorPage> createState() => _AvaliacaoPrestadorPageState();
}

class _AvaliacaoPrestadorPageState extends State<AvaliacaoPrestadorPage> {
  int _nota = 0;
  final TextEditingController _observacoesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma nota')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await AvaliacaoService.criar(
        nota: _nota,
        comentario: _observacoesController.text.trim(),
        solicitacaoId: widget.solicitacao.id,
        avaliadorTipo: 'PRESTADOR',
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ServicoConcluidoPage(isPrestador: true)),
          (route) => false,
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar avaliação')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(showAvatar: true),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.destaque,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.preto,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Serviço finalizado!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.principalEscura,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Você finalizou o serviço, realize uma avaliação ao cliente.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.principal.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final int valorEstrela = index + 1;
                    return GestureDetector(
                      onTap: () => setState(() => _nota = valorEstrela),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Icon(
                          _nota >= valorEstrela
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.destaque,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Text(
                  'Descreva a sua experiência com ${widget.solicitacao.clienteNome}:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _observacoesController,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.principalEscura,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Escreva aqui suas observações...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.principal.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.branco,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _enviar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalEscura,
                    foregroundColor: AppColors.branco,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.branco,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Enviar avaliação',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
