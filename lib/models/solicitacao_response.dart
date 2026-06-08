class SolicitacaoResponse {
  final int id;
  final String descricao;
  final String? dataSolicitacao;
  final String? dataEstimada;
  final double? valorSugerido;
  final String status;
  final int clienteId;
  final String clienteNome;
  final double clienteAvaliacao;
  final int prestadorId;
  final String prestadorNome;
  final String? categoriaNome;
  final bool prestadorConfirmouPagamento;
  final bool clienteConfirmouPagamento;
  final bool clienteAvaliou;
  final bool prestadorAvaliou;

  SolicitacaoResponse({
    required this.id,
    required this.descricao,
    this.dataSolicitacao,
    this.dataEstimada,
    this.valorSugerido,
    required this.status,
    required this.clienteId,
    required this.clienteNome,
    this.clienteAvaliacao = 0.0,
    required this.prestadorId,
    required this.prestadorNome,
    this.categoriaNome,
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
      dataEstimada: json['dataEstimada'],
      valorSugerido: (json['valorSugerido'] as num?)?.toDouble(),
      status: json['status'] ?? '',
      clienteId: json['clienteId'] ?? 0,
      clienteNome: json['clienteNome'] ?? '',
      clienteAvaliacao: (json['clienteAvaliacao'] as num?)?.toDouble() ?? 0.0,
      prestadorId: json['prestadorId'] ?? 0,
      prestadorNome: json['prestadorNome'] ?? '',
      categoriaNome: json['categoriaNome'],
      prestadorConfirmouPagamento:
          json['prestadorConfirmouPagamento'] ?? false,
      clienteConfirmouPagamento:
          json['clienteConfirmouPagamento'] ?? false,
      clienteAvaliou: json['clienteAvaliou'] ?? false,
      prestadorAvaliou: json['prestadorAvaliou'] ?? false,
    );
  }
}
