class MediaAvaliacao {
  final int prestadorId;
  final String prestadorNome;
  final double mediaNotas;
  final int totalAvaliacoes;

  MediaAvaliacao({
    required this.prestadorId,
    required this.prestadorNome,
    required this.mediaNotas,
    required this.totalAvaliacoes,
  });

  factory MediaAvaliacao.fromJson(Map<String, dynamic> json) {
    return MediaAvaliacao(
      prestadorId: json['prestadorId'] ?? 0,
      prestadorNome: json['prestadorNome'] ?? '',
      mediaNotas: (json['mediaNotas'] ?? 0.0).toDouble(),
      totalAvaliacoes: json['totalAvaliacoes'] ?? 0,
    );
  }
}
