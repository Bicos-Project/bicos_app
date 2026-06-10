import '../models/solicitacao_response.dart';
import 'api_client.dart';

class SolicitacaoService {
  static Future<SolicitacaoResponse> criar({
    required int clienteId,
    required int prestadorId,
    required String descricao,
    String? dataSolicitacao,
    DateTime? dataEstimada,
    double? valorSugerido,
  }) async {
    final response = await ApiClient.instance.post(
      '/solicitacoes',
      data: {
        'clienteId': clienteId,
        'prestadorId': prestadorId,
        'descricao': descricao,
        if (dataSolicitacao != null) 'dataSolicitacao': dataSolicitacao,
        if (dataEstimada != null)
          'dataEstimada': dataEstimada.toIso8601String().split('T')[0],
        if (valorSugerido != null) 'valorSugerido': valorSugerido,
      },
    );
    return SolicitacaoResponse.fromJson(response.data);
  }

  static Future<List<SolicitacaoResponse>> listarPorCliente(
      int clienteId) async {
    final response = await ApiClient.instance.get(
      '/solicitacoes',
      queryParameters: {'clienteId': clienteId},
    );
    final list = response.data as List;
    return list
        .map((e) => SolicitacaoResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<SolicitacaoResponse>> listarPorPrestador(
      int prestadorId) async {
    final response = await ApiClient.instance.get(
      '/solicitacoes',
      queryParameters: {'prestadorId': prestadorId},
    );
    final list = response.data as List;
    return list
        .map((e) => SolicitacaoResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<SolicitacaoResponse> avancarStatus(int id) async {
    final response = await ApiClient.instance.patch(
      '/solicitacoes/$id/avancar',
    );
    return SolicitacaoResponse.fromJson(response.data);
  }

  static Future<SolicitacaoResponse> confirmarPagamento(
      int id, String tipo) async {
    final response = await ApiClient.instance.patch(
      '/solicitacoes/$id/confirmar-pagamento',
      queryParameters: {'tipo': tipo},
    );
    return SolicitacaoResponse.fromJson(response.data);
  }

  static Future<SolicitacaoResponse> recusar(int id) async {
    final response = await ApiClient.instance.patch(
      '/solicitacoes/$id/recusar',
    );
    return SolicitacaoResponse.fromJson(response.data);
  }

  static Future<SolicitacaoResponse> cancelar(int id) async {
    return recusar(id);
  }
}
