import 'categoria_model.dart';

class Anuncio {
  final int id;
  final String titulo;
  final String? descricao;
  final double? valorBase;
  final String status;
  final Categoria categoria;
  final int prestadorId;
  final String prestadorNome;

  Anuncio({
    required this.id,
    required this.titulo,
    this.descricao,
    this.valorBase,
    required this.status,
    required this.categoria,
    required this.prestadorId,
    required this.prestadorNome,
  });

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    return Anuncio(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'],
      valorBase: (json['valorBase'] as num?)?.toDouble(),
      status: json['status'] ?? '',
      categoria: Categoria.fromJson(json['categoria'] ?? {}),
      prestadorId: json['prestadorId'] ?? 0,
      prestadorNome: json['prestadorNome'] ?? '',
    );
  }
}
