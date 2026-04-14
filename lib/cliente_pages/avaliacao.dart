import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bicos_app/cliente_pages/slide_prestador_reformas.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AvaliacaoServico extends StatefulWidget {
  final String nomePrestador;

  const AvaliacaoServico({super.key, this.nomePrestador = 'Mariana'});

  @override
  State<AvaliacaoServico> createState() => _AvaliacaoServicoState();
}

class _AvaliacaoServicoState extends State<AvaliacaoServico> {
  int _estrelasSelecionadas = 0;
  int _estrelasPressPreview = 0; // preview ao arrastar o dedo
  final TextEditingController _observacoesController = TextEditingController();

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

  void _enviarAvaliacao() {
    if (_estrelasSelecionadas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selecione pelo menos uma estrela!',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: AppColors.principal,
        ),
      );
      return;
    }
    HapticFeedback.heavyImpact();
    // TODO: enviar avaliação para o backend
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color.fromARGB(255, 52, 7, 63),
              Color.fromARGB(255, 64, 18, 75),
              AppColors.principal,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── HEADER ───────────────────────────────────────
              Stack(
                children: [
                  Image.asset(
                    'assets/header.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/bicos_logo2.png', height: 34),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.destaque,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/perfil.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── CONTEÚDO ─────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card "Serviço finalizado!"
                      _construirCardFinalizado(),

                      const SizedBox(height: 28),

                      // Estrelas interativas
                      Center(child: _construirEstrelas()),

                      const SizedBox(height: 28),

                      // Label
                      Text(
                        'Descreva a sua experiência com ${widget.nomePrestador}:',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.branco,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Campo de texto
                      _construirCampoTexto(),

                      const SizedBox(height: 32),

                      // Botão enviar
                      _construirBotaoEnviar(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ── BOTTOM NAV ───────────────────────────────────
              _construirBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // ── WIDGETS ──────────────────────────────────────────────────────────

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
          // Círculo verde com checkmark
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
          hintText: 'Escreva aqui suas obeservações...',
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ObrasEReformas()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D1F52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
          ),
          child: Text(
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

  Widget _construirBottomNav() {
    // Índice 3 = HISTÓRICO ativo (contexto de onde viemos)
    const int indexAtivo = 3;

    final itens = [
      {'icone': Icons.favorite_border, 'label': 'FAVORITOS', 'index': 0},
      {'icone': Icons.home_outlined, 'label': 'HOME', 'index': 1},
      {'icone': Icons.menu, 'label': 'MENU', 'index': 2},
      {'icone': Icons.history, 'label': 'HISTÓRICO', 'index': 3},
    ];

    return Stack(
      children: [
        Image.asset(
          'assets/bottom.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: itens.map((item) {
              final ativo = (item['index'] as int) == indexAtivo;
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: ativo ? 14 : 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ativo ? AppColors.destaque : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icone'] as IconData,
                        color: ativo
                            ? AppColors.principalEscura
                            : Colors.white70,
                        size: 22,
                      ),
                      if (ativo) ...[
                        const SizedBox(width: 6),
                        Text(
                          item['label'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.principalEscura,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── ESTRELA ARREDONDADA via CustomPainter ─────────────────────────────────

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
    // innerR maior = pontas mais curtas e arredondadas
    final innerR = outerR * 0.52;
    const pontas = 5;
    const angOffset = -math.pi / 2;

    final pontos = <Offset>[];
    for (int i = 0; i < pontas * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final ang = angOffset + (i * math.pi / pontas);
      pontos.add(Offset(cx + r * math.cos(ang), cy + r * math.sin(ang)));
    }

    // Curvas quadráticas com controlPoint mais "puxado" para arredondar
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
      // Glow amarelo por baixo
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.destaque.withOpacity(0.35)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // Preenchimento sólido com gradiente
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
