import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'solicitacao_page.dart';
import 'favoritos_page.dart';
import 'package:bicos_app/cliente_pages/slide_prestador_reformas.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onMudarAbaFavoritos;

  const HomePage({super.key, this.onMudarAbaFavoritos});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<Map<String, dynamic>> categorias = const [
    {
      "nome": "Beleza e Estética",
      "imagem": "assets/beleza.png",
      "emoji": "💅",
      "rota": null,
    },
    {
      "nome": "Serviços Domésticos",
      "imagem": "assets/servicos_domesticos.png",
      "emoji": "🏠",
      "rota": null,
    },
    {
      "nome": "Reparos Rápidos",
      "imagem": "assets/reparos_rapidos.png",
      "emoji": "🔧",
      "rota": null,
    },
    {
      "nome": "Alimentação",
      "imagem": "assets/alimentacao.png",
      "emoji": "🍽️",
      "rota": null,
    },
    {
      "nome": "Obras e Reformas",
      "imagem": "assets/obras.png",
      "emoji": "🔨",
      "rota": "obras",
    },
    {
      "nome": "Logística Local",
      "imagem": "assets/logistica.png",
      "emoji": "🚚",
      "rota": null,
    },
    {
      "nome": "Manutenção Eletrônica",
      "imagem": "assets/eletronica.png",
      "emoji": "⚡",
      "rota": null,
    },
    {
      "nome": "Cuidadores",
      "imagem": "assets/cuidadores.png",
      "emoji": "🤝",
      "rota": null,
    },
  ];

  final List<Map<String, String>> favoritos = const [
    {
      "nome": "Josefino Barros",
      "imagem": "assets/eletricista.png",
      "categoria": "Eletricista",
    },
    {
      "nome": "Carlos Telles",
      "imagem": "assets/pedreiro.png",
      "categoria": "Pedreiro",
    },
    {
      "nome": "Ana Graças",
      "imagem": "assets/cabeleireira.png",
      "categoria": "Cabeleireira",
    },
    {
      "nome": "Judite Anésio",
      "imagem": "assets/trancista.png",
      "categoria": "Trancista",
    },
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
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navegarCategoria(Map<String, dynamic> categoria) {
    HapticFeedback.lightImpact();
    if (categoria["rota"] == "obras") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ObrasEReformas()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _construirHeader(),
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
                  _construirGridCategorias(),
                  const SizedBox(height: 28),
                  _construirHeaderFavoritos(),
                  const SizedBox(height: 14),
                  _construirListaFavoritos(),
                  // AUMENTADO PARA 110: Garante que a barra não tampe o conteúdo
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // (MANTIDO IGUAL)
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
                Container(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: Image.asset('assets/perfil.png', fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // (MANTIDO IGUAL)
  Widget _construirSaudacao() {
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
                  text: 'Usuário!',
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

  // (MANTIDO IGUAL)
  Widget _construirBuscaRapida() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }

  // (MANTIDO IGUAL)
  Widget _construirGridCategorias() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categorias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          return _CategoriaCard(
            categoria: cat,
            temRota: cat["rota"] != null,
            onTap: () => _navegarCategoria(cat),
          );
        },
      ),
    );
  }

  Widget _construirHeaderFavoritos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.destaque.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
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
            ],
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Se a função foi fornecida pela MainNavigation, usa ela para mudar a aba.
                // Se não, faz o push tradicional.
                if (widget.onMudarAbaFavoritos != null) {
                  widget.onMudarAbaFavoritos!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritosPage()),
                  );
                }
              },
              child: Row(
                children: [
                  Text(
                    'Ver todos',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.destaque,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.destaque,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (MANTIDO IGUAL)
  Widget _construirListaFavoritos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: favoritos.map((fav) {
          return _FavoritoCard(
            fav: fav,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SolicitacaoPage()),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── CARD CATEGORIA (MANTIDO IGUAL) ────────────────────────────────────────────

class _CategoriaCard extends StatefulWidget {
  final Map<String, dynamic> categoria;
  final bool temRota;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.categoria,
    required this.temRota,
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
                  color: widget.temRota
                      ? AppColors.destaque.withOpacity(_pressed ? 0.3 : 0.12)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: widget.temRota ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: widget.temRota
                  ? Border.all(
                      color: AppColors.destaque.withOpacity(0.4),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.temRota
                        ? AppColors.destaque.withOpacity(0.15)
                        : AppColors.principal.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.categoria["imagem"]!,
                      width: 26,
                      height: 26,
                      errorBuilder: (_, __, ___) => Text(
                        widget.categoria["emoji"] as String,
                        style: const TextStyle(fontSize: 20),
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
                        widget.categoria["nome"]!,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.principalEscura,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      if (widget.temRota) ...[
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

// ── CARD FAVORITO (MANTIDO IGUAL) ─────────────────────────────────────────────

class _FavoritoCard extends StatefulWidget {
  final Map<String, String> fav;
  final VoidCallback onTap;

  const _FavoritoCard({required this.fav, required this.onTap});

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
                    child: Image.asset(
                      widget.fav["imagem"]!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fav["nome"]!,
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
                            widget.fav["categoria"]!,
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
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.principalEscura.withOpacity(0.3),
                        size: 14,
                      ),
                    ],
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
