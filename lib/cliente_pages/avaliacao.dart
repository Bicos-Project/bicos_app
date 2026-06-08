import 'dart:math' as math;

import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/services/avaliacao_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/shared_pages/servico_concluido.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AvaliacaoServico extends StatefulWidget {
  final SolicitacaoResponse solicitacao;

  const AvaliacaoServico({super.key, required this.solicitacao});

  @override
  State<AvaliacaoServico> createState() => _AvaliacaoServicoState();
}

class _AvaliacaoServicoState extends State<AvaliacaoServico> {
  int _estrelasSelecionadas = 0;
  int _estrelasPressPreview = 0;
  final TextEditingController _observacoesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  void _selecionarEstrela(int index) {
    HapticFeedback.lightImpact();
    setState(() => _estrelasSelecionadas = index);
  }

  void _previewEstrela(int index) {
    if (_estrelasPressPreview != index) {
      HapticFeedback.selectionClick();
      setState(() => _estrelasPressPreview = index);
    }
  }

  void _confirmarPreview() {
    if (_estrelasPressPreview > 0) {
      HapticFeedback.mediumImpact();
      setState(() {
        _estrelasSelecionadas = _estrelasPressPreview;
        _estrelasPressPreview = 0;
      });
    }
  }

  void _cancelarPreview() {
    setState(() => _estrelasPressPreview = 0);
  }

  int get _estrelasExibidas =>
      _estrelasPressPreview > 0 ? _estrelasPressPreview : _estrelasSelecionadas;

  Future<void> _enviar() async {
    if (_estrelasSelecionadas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma nota')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await AvaliacaoService.criar(
        nota: _estrelasSelecionadas,
        comentario: _observacoesController.text.trim(),
        solicitacaoId: widget.solicitacao.id,
        avaliadorTipo: 'CLIENTE',
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ServicoConcluidoPage()),
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
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _construirCardFinalizado(),
                      const SizedBox(height: 28),
                      Center(child: _construirEstrelas()),
                      const SizedBox(height: 28),
                      Text(
                        'Descreva a sua experiência com ${widget.solicitacao.prestadorNome}:',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.branco,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _construirCampoTexto(),
                      const SizedBox(height: 32),
                      _construirBotaoEnviar(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCardFinalizado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.destaque,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.principalEscura,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Serviço finalizado!',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.principalEscura,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirEstrelas() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        final starRowWidth = 5 * 52.0;
        final screenWidth = box.size.width;
        final startX = (screenWidth - starRowWidth) / 2;
        final relX = localPos.dx - startX;
        final index = (relX / 52).ceil().clamp(1, 5);
        _previewEstrela(index);
      },
      onHorizontalDragEnd: (_) => _confirmarPreview(),
      onHorizontalDragCancel: _cancelarPreview,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (i) {
          final index = i + 1;
          final preenchida = index <= _estrelasExibidas;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _selecionarEstrela(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedScale(
                  scale: preenchida ? 1.18 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: preenchida
                        ? _EstrelaSVG(
                            key: ValueKey('filled_$index'),
                            preenchida: true,
                            size: 44,
                          )
                        : _EstrelaSVG(
                            key: ValueKey('empty_$index'),
                            preenchida: false,
                            size: 44,
                          ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _construirCampoTexto() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _observacoesController,
        maxLines: 7,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.principalEscura,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Escreva aqui suas observações...',
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.principalEscura.withOpacity(0.4),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _construirBotaoEnviar() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _enviar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D1F52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
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
                    color: AppColors.branco,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

class _EstrelaSVG extends StatelessWidget {
  final bool preenchida;
  final double size;

  const _EstrelaSVG({super.key, required this.preenchida, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _EstrelaPainter(preenchida: preenchida),
    );
  }
}

class _EstrelaPainter extends CustomPainter {
  final bool preenchida;
  _EstrelaPainter({required this.preenchida});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2 * 0.92;
    final innerR = outerR * 0.52;
    const pontas = 5;
    const angOffset = -math.pi / 2;

    final pontos = <Offset>[];
    for (int i = 0; i < pontas * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final ang = angOffset + (i * math.pi / pontas);
      pontos.add(Offset(cx + r * math.cos(ang), cy + r * math.sin(ang)));
    }

    final path = Path();
    for (int i = 0; i < pontos.length; i++) {
      final curr = pontos[i];
      final next = pontos[(i + 1) % pontos.length];
      final mid = Offset((curr.dx + next.dx) / 2, (curr.dy + next.dy) / 2);
      if (i == 0) {
        path.moveTo(mid.dx, mid.dy);
      } else {
        path.quadraticBezierTo(curr.dx, curr.dy, mid.dx, mid.dy);
      }
    }
    final first = pontos[0];
    final last = pontos[pontos.length - 1];
    final closeMid = Offset((last.dx + first.dx) / 2, (last.dy + first.dy) / 2);
    path.quadraticBezierTo(last.dx, last.dy, closeMid.dx, closeMid.dy);
    path.close();

    if (preenchida) {
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.destaque.withOpacity(0.35)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFEBE84A), AppColors.destaque],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill,
      );
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.destaque.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_EstrelaPainter old) => old.preenchida != preenchida;
}
