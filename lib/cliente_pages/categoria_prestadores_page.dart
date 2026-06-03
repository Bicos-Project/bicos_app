import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../providers/favoritos_provider.dart';
import '../data/prestadores_data.dart';
import 'solicitacao_page.dart';

String emojiDaCategoria(String categoria) {
  final map = {
    'Beleza e Estética': '💅',
    'Serviços Domésticos': '🏠',
    'Reparos Rápidos': '🔧',
    'Alimentação': '🍽️',
    'Obras e Reformas': '🔨',
    'Logística Local': '🚚',
    'Manutenção Eletrônica': '⚡',
    'Cuidadores': '🤝',
  };
  return map[categoria] ?? '💼';
}

class CategoriaPrestadoresPage extends StatefulWidget {
  final String categoria;

  const CategoriaPrestadoresPage({super.key, required this.categoria});

  @override
  State<CategoriaPrestadoresPage> createState() =>
      _CategoriaPrestadoresPageState();
}

class _CategoriaPrestadoresPageState extends State<CategoriaPrestadoresPage> {
  late PageController _pageController;
  int _paginaAtual = 0;
  late List<Prestador> _prestadores;

  @override
  void initState() {
    super.initState();
    _prestadores = prestadoresDaCategoria(widget.categoria);
    _pageController = PageController(viewportFraction: 0.78, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorito(Prestador p) async {
    HapticFeedback.lightImpact();
    if (!mounted) return;
    await context.read<FavoritosProvider>().toggle(p);
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
              _construirHeader(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'Deslize para descobrir profissionais\nqualificados perto de você.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.branco.withOpacity(0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _prestadores.length,
                  onPageChanged: (index) {
                    HapticFeedback.selectionClick();
                    setState(() => _paginaAtual = index);
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double scale = 1.0;
                        double opacity = 1.0;

                        if (_pageController.position.haveDimensions) {
                          final diff =
                              (_pageController.page ?? _paginaAtual.toDouble()) -
                                  index;
                          scale =
                              (1 - diff.abs() * 0.08).clamp(0.88, 1.0);
                          opacity =
                              (1 - diff.abs() * 0.35).clamp(0.5, 1.0);
                        } else {
                          if (index != 0) {
                            scale = 0.92;
                            opacity = 0.65;
                          }
                        }

                        return Transform.scale(
                          scale: scale,
                          child: Opacity(opacity: opacity, child: child),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _construirCard(_prestadores[index]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: _paginaAtual > 0
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
                      child: GestureDetector(
                        onTap: () {
                          if (_paginaAtual > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: _paginaAtual > 0
                              ? AppColors.branco
                              : AppColors.branco.withOpacity(0.3),
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_paginaAtual + 1} / ${_prestadores.length}',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: _paginaAtual < _prestadores.length - 1
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
                      child: GestureDetector(
                        onTap: () {
                          if (_paginaAtual < _prestadores.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Icon(
                          Icons.chevron_right,
                          color: _paginaAtual < _prestadores.length - 1
                              ? AppColors.branco
                              : AppColors.branco.withOpacity(0.3),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirHeader() {
    return Stack(
      children: [
        Image.asset(
          'assets/header.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.branco,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  emojiDaCategoria(widget.categoria),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.categoria,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.destaque,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirCard(Prestador p) {
    final isFav = context.watch<FavoritosProvider>().isFavorito(p.nome);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    p.imagemAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD2C3D9),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                        color: AppColors.principalEscura,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Row(
                      children: [
                        _construirBadge(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: AppColors.principalEscura, size: 13),
                              const SizedBox(width: 3),
                              Text(
                                p.avaliacao.toString(),
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.principalEscura,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          cor: AppColors.destaque,
                        ),
                        const SizedBox(width: 6),
                        _construirBadge(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.principalEscura
                                    .withOpacity(0.8),
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                p.distancia,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.principalEscura,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          cor: AppColors.branco,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            p.nome,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.principalEscura,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          p.especialidade,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.principal,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.principalEscura.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SolicitacaoPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.destaque,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Pedir orçamento',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.principalEscura,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _construirBotaoSecundario(
                            icone: Icons.person_outline,
                            label: 'Ver perfil',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _construirBotaoSecundario(
                            icone:
                                isFav ? Icons.favorite : Icons.favorite_border,
                            label: isFav ? 'Favoritado' : 'Favoritar',
                            onTap: () => _toggleFavorito(p),
                            iconColor:
                                isFav ? Colors.red : AppColors.principalEscura,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirBadge({required Widget child, required Color cor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _construirBotaoSecundario({
    required IconData icone,
    required String label,
    required VoidCallback onTap,
    Color iconColor = AppColors.principalEscura,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.principalEscura.withOpacity(0.25),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 15, color: iconColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.principalEscura,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
