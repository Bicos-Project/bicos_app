import 'dart:io';
import 'package:dio/dio.dart';
import '../models/prestador_cadastro_request.dart';
import 'api_client.dart';

class PrestadorService {
  static Future<PrestadorResponse> cadastrar(
      PrestadorCadastroRequest request) async {
    final response = await ApiClient.instance.post(
      '/prestadores',
      data: request.toJson(),
    );
    return PrestadorResponse.fromJson(response.data);
  }

  static Future<PrestadorResponse> buscarPorId(int id) async {
    final response = await ApiClient.instance.get('/prestadores/$id');
    return PrestadorResponse.fromJson(response.data);
  }

  static Future<PrestadorResponse> atualizar(
      int id, PrestadorCadastroRequest request) async {
    final response = await ApiClient.instance.put(
      '/prestadores/$id',
      data: request.toJson(),
    );
    return PrestadorResponse.fromJson(response.data);
  }

  static Future<List<PrestadorResponse>> listarPorCategoria(
      String nomeCategoria) async {
    final response = await ApiClient.instance.get(
      '/prestadores',
      queryParameters: {'categoriaNome': nomeCategoria},
    );
    final list = response.data as List;
    return list
        .map((e) =>
            PrestadorResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<PrestadorResponse> adicionarFoto(int id, File file) async {
    final formData = FormData.fromMap({
      'foto': await MultipartFile.fromFile(file.path, filename: 'foto.jpg'),
    });
    final response = await ApiClient.instance.post(
      '/prestadores/$id/fotos',
      data: formData,
    );
    return PrestadorResponse.fromJson(response.data);
  }

  static Future<PrestadorResponse> removerFoto(
      int prestadorId, int fotoId) async {
    final response = await ApiClient.instance.delete(
      '/prestadores/$prestadorId/fotos/$fotoId',
    );
    return PrestadorResponse.fromJson(response.data);
  }
}
