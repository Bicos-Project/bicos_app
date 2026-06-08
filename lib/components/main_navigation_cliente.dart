import 'package:bicos_app/inicio_pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../cliente_pages/home_page.dart';
import '../cliente_pages/favoritos_page.dart';
import '../cliente_pages/historico_servicos.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final _solicitacoesKey = GlobalKey<HistoricoServicosState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(), // index 0 → HOME
      const FavoritosPage(), // index 1 → FAVORITOS
      HistoricoServicos(key: _solicitacoesKey), // index 2 → SOLICITAÇÕES
      const MenuApp(), // index 3 → MENU
    ];
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    if (index == 2) {
      _solicitacoesKey.currentState?.reloadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,


      body: IndexedStack(index: _currentIndex, children: _pages),
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

            Positioned.fill(
              child: Image.asset('assets/bottom.png', fit: BoxFit.cover),
            ),

 
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _construirItem(
                    index: 0,
                    iconeAsset: 'assets/home.png',
                    icone: Icons.home_outlined,
                    label: 'HOME',
                  ),
                  _construirItem(
                    index: 1,
                    iconeAsset: 'assets/coracao.png',
                    icone: Icons.favorite_border,
                    label: 'FAVORITOS',
                  ),
                  _construirItem(
                    index: 2,
                    iconeAsset: 'assets/historico.png',
                    icone: Icons.history,
                    label: 'SOLICITAÇÕES',
                  ),
                  _construirItem(
                    index: 3,
                    iconeAsset: 'assets/menu.png',
                    icone: Icons.menu,
                    label: 'MENU',
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
      onTap: () => _onTabSelected(index),
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
