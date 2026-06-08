class AvaliacaoResponse {
  final int id;
  final int nota;
  final String? comentario;
  final int solicitacaoId;
  final int prestadorId;
  final String prestadorNome;
  final int clienteId;
  final String clienteNome;

  AvaliacaoResponse({
    required this.id,
    required this.nota,
    this.comentario,
    required this.solicitacaoId,
    required this.prestadorId,
    required this.prestadorNome,
    required this.clienteId,
    required this.clienteNome,
  });

  factory AvaliacaoResponse.fromJson(Map<String, dynamic> json) {
    return AvaliacaoResponse(
      id: json['id'] ?? 0,
      nota: json['nota'] ?? 0,
      comentario: json['comentario'],
      solicitacaoId: json['solicitacaoId'] ?? 0,
      prestadorId: json['prestadorId'] ?? 0,
      prestadorNome: json['prestadorNome'] ?? '',
      clienteId: json['clienteId'] ?? 0,
      clienteNome: json['clienteNome'] ?? '',
    );
  }
}
