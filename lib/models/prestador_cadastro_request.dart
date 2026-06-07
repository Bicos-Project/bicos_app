import 'endereco_model.dart';
import 'prestador_foto_model.dart';

class PrestadorCadastroRequest {
  final String nome;
  final String email;
  final String cpf;
  final String senha;
  final String? telefone;
  final String? descricao;
  final String? especialidade;
  final EnderecoRequest? endereco;

  PrestadorCadastroRequest({
    required this.nome,
    required this.email,
    required this.cpf,
    required this.senha,
    this.telefone,
    this.descricao,
    this.especialidade,
    this.endereco,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'cpf': cpf,
        'senha': senha,
        if (telefone != null && telefone!.isNotEmpty) 'telefone': telefone,
        if (descricao != null && descricao!.isNotEmpty) 'descricao': descricao,
        if (especialidade != null && especialidade!.isNotEmpty)
          'especialidade': especialidade,
        if (endereco != null) 'endereco': endereco!.toJson(),
      };
}

class PrestadorResponse {
  final int id;
  final String nome;
  final String email;
  final String cpf;
  final String? telefone;
  final String? descricao;
  final String? especialidade;
  final double avaliacao;
  final EnderecoResponse? endereco;
  final List<PrestadorFoto> fotos;

  PrestadorResponse({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpf,
    this.telefone,
    this.descricao,
    this.especialidade,
    this.avaliacao = 0.0,
    this.endereco,
    this.fotos = const [],
  });

  factory PrestadorResponse.fromJson(Map<String, dynamic> json) {
    return PrestadorResponse(
      id: json['id'],
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
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
    );
  }
}
