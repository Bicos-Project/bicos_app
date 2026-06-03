class EnderecoRequest {
  final String cep;
  final String logradouro;
  final String numero;
  final String? complemento;

  EnderecoRequest({
    required this.cep,
    required this.logradouro,
    required this.numero,
    this.complemento,
  });

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'numero': numero,
        if (complemento != null && complemento!.isNotEmpty) 'complemento': complemento,
      };
}

class EnderecoResponse {
  final int id;
  final String cep;
  final String? logradouro;
  final String numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;

  EnderecoResponse({
    required this.id,
    required this.cep,
    this.logradouro,
    required this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
  });

  factory EnderecoResponse.fromJson(Map<String, dynamic> json) {
    return EnderecoResponse(
      id: json['id'],
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'],
      numero: json['numero'] ?? '',
      complemento: json['complemento'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
    );
  }
}
