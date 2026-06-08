import '../models/avaliacao_response.dart';
import '../models/media_avaliacao.dart';
import 'api_client.dart';

class AvaliacaoService {
  static Future<void> criar({
    required int nota,
    required String comentario,
    required int solicitacaoId,
    required String avaliadorTipo,
  }) async {
    await ApiClient.instance.post(
      '/avaliacoes',
      data: {
        'nota': nota,
        'comentario': comentario,
        'solicitacaoId': solicitacaoId,
        'avaliadorTipo': avaliadorTipo,
      },
    );
  }

  static Future<MediaAvaliacao> buscarMedia(int prestadorId) async {
    final response = await ApiClient.instance.get(
      '/avaliacoes/media',
      queryParameters: {'prestadorId': prestadorId},
    );
    return MediaAvaliacao.fromJson(response.data);
  }

  static Future<List<AvaliacaoResponse>> listarPorPrestador(
      int prestadorId) async {
    final response = await ApiClient.instance.get(
      '/avaliacoes',
      queryParameters: {'prestadorId': prestadorId},
    );
    final list = response.data as List;
    return list
        .map((e) => AvaliacaoResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
