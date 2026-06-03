import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import 'api_client.dart';

class AuthService {
  static Future<LoginResponse> loginCliente(
      String email, String senha) async {
    final response = await ApiClient.instance.post(
      '/auth/login/cliente',
      data: LoginRequest(email: email, senha: senha).toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  static Future<LoginResponse> loginPrestador(
      String email, String senha) async {
    final response = await ApiClient.instance.post(
      '/auth/login/prestador',
      data: LoginRequest(email: email, senha: senha).toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  static String extrairErro(DioException e) {
    if (e.response?.data is Map) {
      final msg = e.response?.data['error'];
      if (msg != null) return msg.toString();
      final messages = e.response?.data['messages'];
      if (messages is List && messages.isNotEmpty) {
        return messages.join('\n');
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Sem conexão com o servidor. Verifique se o backend está rodando.';
    }
    return 'Erro inesperado. Tente novamente.';
  }
}
