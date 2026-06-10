import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/core/app_colors.dart';
import 'package:bicos_app/models/avaliacao_response.dart';
import 'package:bicos_app/models/media_avaliacao.dart';
import 'package:bicos_app/services/avaliacao_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MinhasAvaliacoesPage extends StatefulWidget {
  const MinhasAvaliacoesPage({super.key});

  @override
  State<MinhasAvaliacoesPage> createState() => _MinhasAvaliacoesPageState();
}

class _MinhasAvaliacoesPageState extends State<MinhasAvaliacoesPage> {
  MediaAvaliacao? _media;
  List<AvaliacaoResponse> _avaliacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final userData = await AuthStorage.getUserData();
    final prestadorId = userData['id'] as int?;
    if (prestadorId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final media = await AvaliacaoService.buscarMedia(prestadorId);
      final avaliacoes =
          await AvaliacaoService.listarPorPrestador(prestadorId);
      if (mounted) {
        setState(() {
          _media = media;
          _avaliacoes = avaliacoes;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(
          showBack: true,
          centerTitle: true,
          title: 'Minhas Avaliações',
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.destaque),
            )
          : RefreshIndicator(
              onRefresh: _carregar,
              color: AppColors.destaque,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (_media != null) _buildMediaCard(),
                  const SizedBox(height: 24),
                  if (_avaliacoes.isEmpty)
                    const Center(
                      child: Text(
                        'Nenhuma avaliação ainda',
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    )
                  else
                    ..._avaliacoes.map(_buildAvaliacaoCard),
                ],
              ),
            ),
    );
  }

  Widget _buildMediaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.destaque.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _media!.mediaNotas.toStringAsFixed(1),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.principalEscura,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (i) {
                  final estrela = i < _media!.mediaNotas.round()
                      ? Icons.star
                      : Icons.star_border;
                  return Icon(estrela, color: AppColors.destaque, size: 18);
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${_media!.totalAvaliacoes} avaliação${_media!.totalAvaliacoes == 1 ? '' : 'ões'}',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvaliacaoCard(AvaliacaoResponse a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.principalEscura.withOpacity(0.1),
                child: Text(
                  a.clienteNome.isNotEmpty
                      ? a.clienteNome[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.principalEscura,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  a.clienteNome,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.preto,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < a.nota ? Icons.star : Icons.star_border,
                    color: AppColors.destaque,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          if (a.comentario != null && a.comentario!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              a.comentario!,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
