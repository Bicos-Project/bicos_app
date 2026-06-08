class SolicitacaoResponse {
  final int id;
  final String descricao;
  final String? dataSolicitacao;
  final String status;
  final int clienteId;
  final String clienteNome;
  final int anuncioId;
  final String? anuncioTitulo;
  final int prestadorId;
  final String prestadorNome;
  final bool prestadorConfirmouPagamento;
  final bool clienteConfirmouPagamento;
  final bool clienteAvaliou;
  final bool prestadorAvaliou;

  SolicitacaoResponse({
    required this.id,
    required this.descricao,
    this.dataSolicitacao,
    required this.status,
    required this.clienteId,
    required this.clienteNome,
    required this.anuncioId,
    this.anuncioTitulo,
    required this.prestadorId,
    required this.prestadorNome,
    this.prestadorConfirmouPagamento = false,
    this.clienteConfirmouPagamento = false,
    this.clienteAvaliou = false,
    this.prestadorAvaliou = false,
  });

  factory SolicitacaoResponse.fromJson(Map<String, dynamic> json) {
    return SolicitacaoResponse(
      id: json['id'] ?? 0,
      descricao: json['descricao'] ?? '',
      dataSolicitacao: json['dataSolicitacao'],
      status: json['status'] ?? '',
      clienteId: json['clienteId'] ?? 0,
      clienteNome: json['clienteNome'] ?? '',
      anuncioId: json['anuncioId'] ?? 0,
      anuncioTitulo: json['anuncioTitulo'],
      prestadorId: json['prestadorId'] ?? 0,
      prestadorNome: json['prestadorNome'] ?? '',
      prestadorConfirmouPagamento:
          json['prestadorConfirmouPagamento'] ?? false,
      clienteConfirmouPagamento:
          json['clienteConfirmouPagamento'] ?? false,
      clienteAvaliou: json['clienteAvaliou'] ?? false,
      prestadorAvaliou: json['prestadorAvaliou'] ?? false,
    );
  }
}
