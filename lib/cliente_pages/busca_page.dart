import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/app_header.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../models/prestador_cadastro_request.dart';
import '../providers/favoritos_provider.dart';
import '../components/app_image.dart';
import '../services/prestador_service.dart';
import 'perfil_prestador_page.dart';

class BuscaPage extends StatefulWidget {
  final String query;
  const BuscaPage({super.key, required this.query});

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  late final TextEditingController _controller;
  List<Prestador> _resultados = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    _buscar(widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buscar(String q) async {
    final termo = q.trim();
    if (termo.isEmpty) {
      setState(() => _resultados = []);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final lista = await PrestadorService.buscar(termo);
      if (!mounted) return;
      setState(() {
        _resultados = lista.map((r) => _paraPrestador(r)).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Prestador _paraPrestador(PrestadorResponse r) {
    final fotosUrls = r.fotos.map((f) => f.url).toList();
    return Prestador(
      id: r.id,
      nome: r.nome,
      especialidade: r.especialidade ?? '',
      descricao: r.descricao ?? '',
      imagemAsset: fotosUrls.isNotEmpty ? fotosUrls.first : '',
      avaliacao: r.avaliacao,
      distancia: '',
      categoria: '',
      fotosUrls: fotosUrls,
    );
  }

  Widget _imagemBusca(String src) {
    return AppImage(src, width: 48, height: 48);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(showBack: true, searchController: _controller, onSearchChanged: _buscar),
            const SizedBox(height: 16),
            Expanded(child: _construirResultados()),
          ],
        ),
      ),
    );
  }

  Widget _construirResultados() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.destaque),
      );
    }

    if (_resultados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: AppColors.branco.withOpacity(0.25),
            ),
            const SizedBox(height: 16),
            Text(
              _controller.text.trim().isEmpty
                  ? 'Digite o nome do serviço ou profissional'
                  : 'Nenhum resultado encontrado',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.branco.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _resultados.length,
      itemBuilder: (context, index) {
        final p = _resultados[index];
        final isFav = context.watch<FavoritosProvider>().isFavorito(p.nome);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PerfilPrestadorPage(prestador: p),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      child: _imagemBusca(p.imagemAsset),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.nome,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.principalEscura,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.principal.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              p.especialidade,
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
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          p.avaliacao.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.principalEscura,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isFav ? Colors.red : AppColors.principalEscura.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}