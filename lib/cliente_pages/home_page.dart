import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/app_header.dart';
import '../components/mapa_home.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/categoria_service.dart';
import '../providers/favoritos_provider.dart';
import '../components/app_image.dart';
import '../models/categoria_model.dart';
import '../models/prestador_model.dart';
import 'busca_page.dart';
import 'categoria_prestadores_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  List<Categoria> _categorias = [];
  bool _isLoading = true;

  static const List<Map<String, dynamic>> _categoriasFallback = [
    {'nome': 'Beleza e Estética', 'imagem': 'assets/beleza.png', 'emoji': '💅'},
    {'nome': 'Serviços Domésticos', 'imagem': 'assets/servicos_domesticos.png', 'emoji': '🏠'},
    {'nome': 'Reparos Rápidos', 'imagem': 'assets/reparos_rapidos.png', 'emoji': '🔧'},
    {'nome': 'Alimentação', 'imagem': 'assets/alimentacao.png', 'emoji': '🍽️'},
    {'nome': 'Obras e Reformas', 'imagem': 'assets/obras.png', 'emoji': '🔨'},
    {'nome': 'Logística Local', 'imagem': 'assets/logistica.png', 'emoji': '🚚'},
    {'nome': 'Manutenção Eletrônica', 'imagem': 'assets/eletronica.png', 'emoji': '⚡'},
    {'nome': 'Cuidadores', 'imagem': 'assets/cuidadores.png', 'emoji': '🤝'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final categorias = await CategoriaService.listar();
      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navegarCategoria(String nome) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoriaPrestadoresPage(categoria: nome),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _carregarCategorias,
        color: AppColors.destaque,
        backgroundColor: AppColors.principal,
        child: Container(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppHeader(showAvatar: true),
                    const SizedBox(height: 24),
                    _construirSaudacao(),
                    const SizedBox(height: 20),
                    _construirBuscaRapida(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Categorias',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.branco,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.destaque,
                              ),
                            ),
                          )
                        : _construirGridCategorias(),
                    const SizedBox(height: 16),
                    const MapaHome(),
                    const SizedBox(height: 16),
                    if (context.watch<FavoritosProvider>().favoritos.isNotEmpty) ...[
                      _construirHeaderFavoritos(),
                      const SizedBox(height: 14),
                      _construirListaFavoritos(),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirSaudacao() {
    final nome = context.watch<AuthProvider>().nome ?? 'Usuário';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Olá, ',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.branco.withOpacity(0.85),
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '$nome!',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.branco,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Encontre serviços próximos a você',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.branco.withOpacity(0.6),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBuscaRapida() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BuscaPage(query: ''),
            ),
          ),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.branco.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.branco.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: AppColors.branco.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Buscar serviço ou profissional...',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.branco.withOpacity(0.4),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirGridCategorias() {
    final lista = _categorias.isNotEmpty
        ? _categorias.map((c) => {'nome': c.nome, 'imagem': c.assetName}).toList()
        : _categoriasFallback;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lista.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          final cat = lista[index];
          return _CategoriaCard(
            nome: cat['nome'] as String,
            imagem: cat['imagem'] as String,
            onTap: () => _navegarCategoria(cat['nome'] as String),
          );
        },
      ),
    );
  }

  Widget _construirHeaderFavoritos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.destaque.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.favorite,
              color: AppColors.destaque,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Favoritos',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.branco,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.read<FavoritosProvider>().carregar(),
              child: const Icon(
                Icons.refresh,
                color: AppColors.destaque,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirListaFavoritos() {
    final favs = context.watch<FavoritosProvider>().favoritos;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: favs.map((p) {
          return _FavoritoCard(
            prestador: p,
            onTap: () => _navegarCategoria(p.categoria),
          );
        }).toList(),
      ),
    );
  }
}

class _FavoritoCard extends StatefulWidget {
  final Prestador prestador;
  final VoidCallback onTap;

  const _FavoritoCard({required this.prestador, required this.onTap});

  @override
  State<_FavoritoCard> createState() => _FavoritoCardState();
}

class _FavoritoCardState extends State<_FavoritoCard> {
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
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    child: AppImage(
                      widget.prestador.imagemAsset,
                      width: 52,
                      height: 52,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
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
                      ],
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.red.shade400,
                    size: 20,
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

class _CategoriaCard extends StatefulWidget {
  final String nome;
  final String imagem;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.nome,
    required this.imagem,
    required this.onTap,
  });

  @override
  State<_CategoriaCard> createState() => _CategoriaCardState();
}

class _CategoriaCardState extends State<_CategoriaCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: _pressed
                  ? AppColors.branco.withOpacity(0.92)
                  : AppColors.branco,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.destaque.withOpacity(_pressed ? 0.3 : 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: AppColors.destaque.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.destaque.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.imagem,
                      width: 26,
                      height: 26,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.category,
                        size: 20,
                        color: AppColors.principal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nome,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.principalEscura,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            'Ver serviços',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.principal,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 8,
                            color: AppColors.principal,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
