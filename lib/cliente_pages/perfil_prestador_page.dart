import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/app_header.dart';
import '../components/app_image.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import 'solicitacao_page.dart';

class PerfilPrestadorPage extends StatefulWidget {
  final Prestador prestador;

  const PerfilPrestadorPage({super.key, required this.prestador});

  @override
  State<PerfilPrestadorPage> createState() => _PerfilPrestadorPageState();
}

class _PerfilPrestadorPageState extends State<PerfilPrestadorPage> {
  int _fotoAtual = 0;

  List<String> get _fotos {
    if (widget.prestador.fotosUrls.isNotEmpty) {
      return widget.prestador.fotosUrls;
    }
    if (widget.prestador.imagemAsset.isNotEmpty) {
      return [widget.prestador.imagemAsset];
    }
    return [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prestador;
    final fotos = _fotos;

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(showBack: true, title: 'Perfil Prestador'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      if (fotos.isEmpty)
                        _imagemFallback()
                      else ...[
                        ...fotos.asMap().entries.map((e) =>
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: _fotoAtual == e.key ? 1 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: e.value == fotos.first && _fotoAtual != e.key
                                  ? const SizedBox.shrink()
                                  : AppImage(e.value, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        if (fotos.length > 1) ...[
                          Positioned(
                            left: 8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_fotoAtual > 0) {
                                      setState(() => _fotoAtual--);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_fotoAtual < fotos.length - 1) {
                                      setState(() => _fotoAtual++);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                fotos.length,
                                (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: _fotoAtual == i ? 24 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _fotoAtual == i
                                        ? AppColors.destaque
                                        : Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.branco.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.branco.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p.nome,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.branco,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (p.especialidade.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.destaque,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  p.especialidade,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.principalEscura,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < p.avaliacao.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppColors.destaque,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              p.avaliacao == 0.0
                                  ? 'Sem avaliações'
                                  : p.avaliacao.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.branco.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (p.distancia.isNotEmpty) ...[
                              const SizedBox(width: 16),
                              Icon(Icons.location_on_outlined,
                                  color: AppColors.destaque.withOpacity(0.7),
                                  size: 18),
                              const SizedBox(width: 4),
                              Text(
                                p.distancia,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.branco.withOpacity(0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Sobre',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.destaque,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.descricao,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.branco.withOpacity(0.85),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SolicitacaoPage(prestador: p),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagemFallback() {
    return Container(
      color: const Color(0xFFD2C3D9),
      child: const Icon(Icons.person, size: 64, color: AppColors.principalEscura),
    );
  }
}
