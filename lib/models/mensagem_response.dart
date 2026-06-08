class MensagemResponse {
  final int id;
  final int solicitacaoId;
  final int remetenteId;
  final String tipoRemetente;
  final String texto;
  final String? dataHora;

  MensagemResponse({
    required this.id,
    required this.solicitacaoId,
    required this.remetenteId,
    required this.tipoRemetente,
    required this.texto,
    this.dataHora,
  });

  factory MensagemResponse.fromJson(Map<String, dynamic> json) {
    return MensagemResponse(
      id: json['id'] ?? 0,
      solicitacaoId: json['solicitacaoId'] ?? 0,
      remetenteId: json['remetenteId'] ?? 0,
      tipoRemetente: json['tipoRemetente'] ?? '',
      texto: json['texto'] ?? '',
      dataHora: json['dataHora'],
    );
  }
}
