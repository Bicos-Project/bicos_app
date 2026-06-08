import 'endereco_model.dart';
import 'prestador_foto_model.dart';

class PrestadorProximoResponse {
  final int id;
  final String nome;
  final String? email;
  final String? telefone;
  final String? descricao;
  final String? especialidade;
  final double avaliacao;
  final EnderecoResponse? endereco;
  final List<PrestadorFoto> fotos;
  final double distanciaKm;

  PrestadorProximoResponse({
    required this.id,
    required this.nome,
    this.email,
    this.telefone,
    this.descricao,
    this.especialidade,
    this.avaliacao = 0.0,
    this.endereco,
    this.fotos = const [],
    required this.distanciaKm,
  });

  factory PrestadorProximoResponse.fromJson(Map<String, dynamic> json) {
    return PrestadorProximoResponse(
      id: json['id'],
      nome: json['nome'] ?? '',
      email: json['email'],
      telefone: json['telefone'],
      descricao: json['descricao'],
      especialidade: json['especialidade'],
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 0.0,
      endereco: json['endereco'] != null
          ? EnderecoResponse.fromJson(json['endereco'])
          : null,
      fotos: (json['fotos'] as List?)
              ?.map((f) => PrestadorFoto.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
      distanciaKm: (json['distanciaKm'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
