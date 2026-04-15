import 'package:bicos_app/inicio_pages/menu.dart';
import 'package:bicos_app/prestador_pages/andamento_servico.dart';
import 'package:bicos_app/prestador_pages/home_page_prestador.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../prestador_pages/visualizacao_chats.dart';
import '../prestador_pages/historico_servico.dart';

class MainNavigationPrestador extends StatefulWidget {
  const MainNavigationPrestador({super.key});

  @override
  State<MainNavigationPrestador> createState() => _MainNavigationPrestadorState();
}

class _MainNavigationPrestadorState extends State<MainNavigationPrestador> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const VisualizacaoChats(), // index 0 → FAVORITOS
    const HomePagePrestador(title: 'HOME',), // index 1 → HOME
    const MenuApp(), // index 2 → MENU
    const HistoricoServicoRealizadoPage(), // index 3 → HISTÓRICO
    const AndamentoServicoPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.principal,

      // ── BODY: mostra a página ativa ──────────────────────────
      body: IndexedStack(index: _currentIndex, children: _pages),

      // ── BOTTOM NAV ───────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: _construirBottomNav(),
      ),
    );
  }

  Widget _construirBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            // Fundo (imagem)
            Positioned.fill(
              child: Image.asset('assets/bottom.png', fit: BoxFit.cover),
            ),

            // Itens por cima
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _construirItem(
                    index: 0,
                    iconeAsset: 'assets/chat.png',
                    icone: Icons.message,
                    label: 'CHATS',
                  ),
                  _construirItem(
                    index: 1,
                    iconeAsset: 'assets/home.png',
                    icone: Icons.home_outlined,
                    label: 'HOME',
                  ),
                  _construirItem(
                    index: 2,
                    iconeAsset: 'assets/menu.png',
                    icone: Icons.menu,
                    label: 'MENU',
                  ),
                  _construirItem(
                    index: 3,
                    iconeAsset: 'assets/historico.png',
                    icone: Icons.history,
                    label: 'HISTÓRICO',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirItem({
    required int index,
    required String iconeAsset,
    required IconData icone,
    required String label,
  }) {
    final bool ativo = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: ativo
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: ativo ? AppColors.destaque : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tenta carregar o asset; se não existir, usa ícone Material
            _iconeNav(iconeAsset, icone, ativo),
            if (ativo) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.principalEscura,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _iconeNav(String asset, IconData fallback, bool ativo) {
    // Usa Image.asset se o arquivo existir, com tratamento de erro via errorBuilder
    return Image.asset(
      asset,
      width: 22,
      height: 22,
      color: ativo ? AppColors.principalEscura : Colors.white70,
      errorBuilder: (_, __, ___) => Icon(
        fallback,
        size: 22,
        color: ativo ? AppColors.principalEscura : Colors.white70,
      ),
    );
  }
}
