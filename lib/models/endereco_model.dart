class EnderecoRequest {
  final String cep;
  final String logradouro;
  final String numero;
  final String? complemento;
  final double? latitude;
  final double? longitude;
  final String? bairro;
  final String? cidade;
  final String? estado;

  EnderecoRequest({
    required this.cep,
    required this.logradouro,
    required this.numero,
    this.complemento,
    this.latitude,
    this.longitude,
    this.bairro,
    this.cidade,
    this.estado,
  });

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'numero': numero,
        if (complemento != null && complemento!.isNotEmpty) 'complemento': complemento,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (bairro != null && bairro!.isNotEmpty) 'bairro': bairro,
        if (cidade != null && cidade!.isNotEmpty) 'cidade': cidade,
        if (estado != null && estado!.isNotEmpty) 'estado': estado,
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
  final double? latitude;
  final double? longitude;

  EnderecoResponse({
    required this.id,
    required this.cep,
    this.logradouro,
    required this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.latitude,
    this.longitude,
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
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
