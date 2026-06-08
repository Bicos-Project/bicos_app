import '../models/mensagem_response.dart';
import 'api_client.dart';

class MensagemService {
  static Future<List<MensagemResponse>> listar(int solicitacaoId) async {
    final response = await ApiClient.instance.get(
      '/mensagens',
      queryParameters: {'solicitacaoId': solicitacaoId},
    );
    final list = response.data as List;
    return list
        .map((e) => MensagemResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<MensagemResponse> enviar({
    required int solicitacaoId,
    required int remetenteId,
    required String tipoRemetente,
    required String texto,
  }) async {
    final response = await ApiClient.instance.post(
      '/mensagens',
      data: {
        'solicitacaoId': solicitacaoId,
        'remetenteId': remetenteId,
        'tipoRemetente': tipoRemetente,
        'texto': texto,
      },
    );
    return MensagemResponse.fromJson(response.data);
  }
}
