import 'endereco_model.dart';

class ClienteCadastroRequest {
  final String nome;
  final String email;
  final String cpf;
  final String senha;
  final String? telefone;
  final EnderecoRequest? endereco;

  ClienteCadastroRequest({
    required this.nome,
    required this.email,
    required this.cpf,
    required this.senha,
    this.telefone,
    this.endereco,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'cpf': cpf,
        'senha': senha,
        if (telefone != null && telefone!.isNotEmpty) 'telefone': telefone,
        if (endereco != null) 'endereco': endereco!.toJson(),
      };
}

class ClienteResponse {
  final int id;
  final String nome;
  final String email;
  final String cpf;
  final String? telefone;
  final EnderecoResponse? endereco;
  final String? fotoUrl;

  ClienteResponse({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpf,
    this.telefone,
    this.endereco,
    this.fotoUrl,
  });

  factory ClienteResponse.fromJson(Map<String, dynamic> json) {
    return ClienteResponse(
      id: json['id'],
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      telefone: json['telefone'],
      endereco: json['endereco'] != null
          ? EnderecoResponse.fromJson(json['endereco'])
          : null,
      fotoUrl: json['fotoUrl'],
    );
  }
}
