import '../models/categoria_model.dart';
import 'api_client.dart';

class CategoriaService {
  static Future<List<Categoria>> listar() async {
    final response = await ApiClient.instance.get('/categorias');
    return (response.data as List)
        .map((e) => Categoria.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
