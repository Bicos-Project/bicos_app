class Prestador {
  final int? id;
  final String nome;
  final String especialidade;
  final String descricao;
  final String imagemAsset;
  final double avaliacao;
  final String distancia;
  final double distanciaKm;
  final String categoria;
  final List<String> fotosUrls;

  const Prestador({
    this.id,
    required this.nome,
    required this.especialidade,
    required this.descricao,
    required this.imagemAsset,
    required this.avaliacao,
    required this.distancia,
    this.distanciaKm = double.infinity,
    required this.categoria,
    this.fotosUrls = const [],
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        'especialidade': especialidade,
        'descricao': descricao,
        'imagemAsset': imagemAsset,
        'avaliacao': avaliacao,
        'distancia': distancia,
        'categoria': categoria,
        if (fotosUrls.isNotEmpty) 'fotosUrls': fotosUrls,
      };

  factory Prestador.fromJson(Map<String, dynamic> json) => Prestador(
        id: json['id'] as int?,
        nome: json['nome'] as String,
        especialidade: json['especialidade'] as String,
        descricao: json['descricao'] as String,
        imagemAsset: json['imagemAsset'] as String,
        avaliacao: (json['avaliacao'] as num).toDouble(),
        distancia: json['distancia'] as String,
        categoria: json['categoria'] as String,
        fotosUrls: json['fotosUrls'] != null
            ? List<String>.from(json['fotosUrls'] as List)
            : const [],
      );

  factory Prestador.fromResponseDTO(Map<String, dynamic> json) {
    final fotos = json['fotos'] as List?;
    return Prestador(
      id: json['id'] as int?,
      nome: json['nome'] as String? ?? '',
      especialidade: json['especialidade'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      imagemAsset: fotos != null && fotos.isNotEmpty
          ? (fotos.first['url'] as String? ?? '')
          : '',
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 0.0,
      distancia: '',
      distanciaKm: double.infinity,
      categoria: json['categoria'] is Map
          ? (json['categoria']['nome'] as String? ?? '')
          : (json['categoria'] as String? ?? ''),
      fotosUrls: fotos != null
          ? fotos.map((f) => f['url'] as String).toList()
          : const [],
    );
  }
}
