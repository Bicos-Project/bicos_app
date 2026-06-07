class Prestador {
  final int? id;
  final String nome;
  final String especialidade;
  final String descricao;
  final String imagemAsset;
  final double avaliacao;
  final String distancia;
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
}
