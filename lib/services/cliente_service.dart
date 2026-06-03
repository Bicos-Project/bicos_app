import '../models/cliente_model.dart';
import 'api_client.dart';

class ClienteService {
  static Future<ClienteResponse> cadastrar(
      ClienteCadastroRequest request) async {
    final response = await ApiClient.instance.post(
      '/clientes',
      data: request.toJson(),
    );
    return ClienteResponse.fromJson(response.data);
  }

  static Future<ClienteResponse> buscarPorId(int id) async {
    final response = await ApiClient.instance.get('/clientes/$id');
    return ClienteResponse.fromJson(response.data);
  }

  static Future<ClienteResponse> atualizar(
      int id, ClienteCadastroRequest request) async {
    final response = await ApiClient.instance.put(
      '/clientes/$id',
      data: request.toJson(),
    );
    return ClienteResponse.fromJson(response.data);
  }
}
