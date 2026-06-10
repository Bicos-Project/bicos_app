import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../models/prestador_proximo_response.dart';
import '../services/prestador_service.dart';
import '../cliente_pages/perfil_prestador_page.dart';

class MapaHome extends StatefulWidget {
  const MapaHome({super.key});

  @override
  State<MapaHome> createState() => _MapaHomeState();
}

class _MapaHomeState extends State<MapaHome> {
  LatLng? _userLocation;
  List<PrestadorProximoResponse> _prestadores = [];
  bool _isLoading = true;

  static const _defaultCenter = LatLng(-8.0476, -34.8770); // Recife

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _loadPrestadores(_defaultCenter);
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _loadPrestadores(_defaultCenter);
        return;
      }
      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      );
      _loadPrestadores(LatLng(pos.latitude, pos.longitude));
    } catch (_) {
      _loadPrestadores(_defaultCenter);
    }
  }

  Future<void> _loadPrestadores(LatLng center) async {
    try {
      final prestadores = await PrestadorService.listarProximos(
        lat: center.latitude,
        lng: center.longitude,
        raioKm: 50,
      );
      if (mounted) {
        setState(() {
          _userLocation = center;
          _prestadores = prestadores;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _userLocation = center;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.destaque),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
                  Icons.location_on_outlined,
                  color: AppColors.destaque,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Prestadores próximos',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.branco,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _userLocation ?? _defaultCenter,
                  initialZoom: 13,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onTap: (_, __) {},
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.bicos.app',
                  ),
                  if (_userLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                            point: _userLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 36,
                            ),
                          ),
                          ..._prestadores
                              .where((p) =>
                                  p.endereco?.latitude != null &&
                                  p.endereco?.longitude != null)
                              .map((p) {
                          final cor = _coresPorIndice(
                              _prestadores.indexOf(p));
                          return Marker(
                            point: LatLng(
                              p.endereco!.latitude!,
                              p.endereco!.longitude!,
                            ),
                            width: 80,
                            height: 100,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PerfilPrestadorPage(
                                      prestador: _toPrestador(p),
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.principalEscura,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      p.nome,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Icon(
                                    Icons.person_pin_circle,
                                    color: cor,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_prestadores.isNotEmpty) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _prestadores.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final p = _prestadores[i];
                  return _PrestadorChip(
                    nome: p.nome,
                    distancia: p.distanciaKm,
                    cor: _coresPorIndice(i),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PerfilPrestadorPage(
                            prestador: _toPrestador(p),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Prestador _toPrestador(PrestadorProximoResponse p) {
    return Prestador(
      id: p.id,
      nome: p.nome,
      especialidade: p.especialidade ?? '',
      descricao: p.descricao ?? '',
      imagemAsset: '',
      avaliacao: p.avaliacao,
      distancia: '${p.distanciaKm.toStringAsFixed(1)} km',
      categoria: '',
      fotosUrls: p.fotos.map((f) => f.url).toList(),
    );
  }

  Color _coresPorIndice(int i) {
    const cores = [
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.brown,
    ];
    return cores[i % cores.length];
  }
}

class _PrestadorChip extends StatelessWidget {
  final String nome;
  final double distancia;
  final Color cor;
  final VoidCallback onTap;

  const _PrestadorChip({
    required this.nome,
    required this.distancia,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.branco,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_pin, size: 16, color: cor),
            const SizedBox(width: 4),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.principalEscura,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${distancia.toStringAsFixed(1)} km',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.principalEscura.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
