import '../models/anuncio_model.dart';
import 'api_client.dart';

class AnuncioService {
  static Future<List<Anuncio>> listarPorPrestador(int prestadorId) async {
    final response = await ApiClient.instance.get(
      '/anuncios',
      queryParameters: {'prestadorId': prestadorId},
    );
    final list = response.data as List;
    return list
        .map((e) => Anuncio.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
