import 'dart:io';
import 'package:dio/dio.dart';
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

  static Future<ClienteResponse> atualizarFoto(int id, File file) async {
    final formData = FormData.fromMap({
      'foto': await MultipartFile.fromFile(file.path, filename: 'foto.jpg'),
    });
    final response = await ApiClient.instance.put(
      '/clientes/$id/foto',
      data: formData,
    );
    return ClienteResponse.fromJson(response.data);
  }
}
