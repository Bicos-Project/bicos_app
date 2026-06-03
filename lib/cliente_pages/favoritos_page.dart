import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../providers/favoritos_provider.dart';
import 'categoria_prestadores_page.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  Future<void> _remover(Prestador p) async {
    await context.read<FavoritosProvider>().remover(p.nome);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.nome} removido dos favoritos'),
        backgroundColor: AppColors.principalEscura,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: AppColors.destaque,
          onPressed: () async {
            if (!mounted) return;
            await context.read<FavoritosProvider>().toggle(p);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<FavoritosProvider>().favoritos;

    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Column(
          children: [
            _construirHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: favoritos.isEmpty
                  ? _construirVazio()
                  : RefreshIndicator(
                      onRefresh: () => context.read<FavoritosProvider>().carregar(),
                      color: AppColors.destaque,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: favoritos.length,
                        itemBuilder: (context, index) {
                          final p = favoritos[index];
                          return _FavoritoItem(
                            prestador: p,
                            onRemover: () => _remover(p),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoriaPrestadoresPage(
                                    categoria: p.categoria),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.branco.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum favorito ainda',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.branco.withOpacity(0.5),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Salve profissionais que você gostou\npara encontrá-los facilmente depois',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.branco.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirHeader() {
    return Stack(
      children: [
        Image.asset('assets/header.png', fit: BoxFit.fill),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/bicos_logo2.png', height: 32),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: AppColors.destaque,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Favoritos',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.branco,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoritoItem extends StatefulWidget {
  final Prestador prestador;
  final VoidCallback onRemover;
  final VoidCallback onTap;

  const _FavoritoItem({
    required this.prestador,
    required this.onRemover,
    required this.onTap,
  });

  @override
  State<_FavoritoItem> createState() => _FavoritoItemState();
}

class _FavoritoItemState extends State<_FavoritoItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.branco,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.prestador.imagemAsset,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 52,
                        height: 52,
                        color: AppColors.principalEscura,
                        child: const Icon(Icons.person,
                            color: AppColors.branco, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prestador.nome,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.principalEscura,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.principal.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.prestador.especialidade,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.principal,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  widget.prestador.avaliacao.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.principalEscura,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 22),
                    onPressed: widget.onRemover,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
