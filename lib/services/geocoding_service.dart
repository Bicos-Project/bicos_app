import 'package:dio/dio.dart';

class GeocodingService {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Future<ViaCepResponse?> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return null;
    try {
      final response = await _dio.get(
        'https://viacep.com.br/ws/$cepLimpo/json/',
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('erro')) return null;
        return ViaCepResponse(
          logradouro: data['logradouro'] ?? '',
          bairro: data['bairro'] ?? '',
          cidade: data['localidade'] ?? '',
          estado: data['uf'] ?? '',
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<GeoCoord?> geocode(
      String logradouro, String bairro, String cidade, String estado) async {
    final endereco =
        '$logradouro, $bairro, $cidade, $estado, Brasil'.replaceAll(' ', '+');
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': endereco,
          'format': 'json',
          'limit': 1,
        },
        options: Options(headers: {
          'User-Agent': 'BicosApp/1.0',
        }),
      );
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        if (list.isNotEmpty) {
          final loc = list[0] as Map<String, dynamic>;
          return GeoCoord(
            latitude: double.parse(loc['lat']),
            longitude: double.parse(loc['lon']),
          );
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

class ViaCepResponse {
  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;

  ViaCepResponse({
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });
}

class GeoCoord {
  final double latitude;
  final double longitude;

  GeoCoord({required this.latitude, required this.longitude});
}
