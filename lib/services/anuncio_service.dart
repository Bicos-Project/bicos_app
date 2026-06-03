import '../models/anuncio_model.dart';
import 'api_client.dart';

class AnuncioService {
  static Future<List<Anuncio>> listarAtivos() async {
    final response = await ApiClient.instance.get('/anuncios');
    return (response.data as List)
        .map((e) => Anuncio.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
