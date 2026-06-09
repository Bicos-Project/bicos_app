import '../models/prestador_model.dart';
import '../storage/auth_storage.dart';
import 'api_client.dart';

class FavoritosService {
  static Future<int?> _getClienteId() async {
    final data = await AuthStorage.getUserData();
    return data['id'] as int?;
  }

  static Future<List<Prestador>> listar() async {
    try {
      final clienteId = await _getClienteId();
      if (clienteId == null) return [];
      final response = await ApiClient.instance.get('/favoritos/$clienteId');
      final list = response.data as List;
      return list
          .map((e) => Prestador.fromResponseDTO(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> toggle(Prestador prestador) async {
    if (prestador.id == null) return;
    try {
      final clienteId = await _getClienteId();
      if (clienteId == null) return;
      await ApiClient.instance.post('/favoritos/$clienteId/${prestador.id}');
    } catch (_) {}
  }

  static Future<bool> isFavorito(String nome) async {
    final lista = await listar();
    return lista.any((p) => p.nome == nome);
  }

  static Future<void> remover(String nome) async {
    try {
      final lista = await listar();
      final p = lista.where((p) => p.nome == nome).firstOrNull;
      if (p?.id != null) {
        final clienteId = await _getClienteId();
        if (clienteId == null) return;
        await ApiClient.instance.delete(
          '/favoritos/$clienteId/${p!.id}',
        );
      }
    } catch (_) {}
  }
}
