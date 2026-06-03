class Prestador {
  final String nome;
  final String especialidade;
  final String descricao;
  final String imagemAsset;
  final double avaliacao;
  final String distancia;
  final String categoria;

  const Prestador({
    required this.nome,
    required this.especialidade,
    required this.descricao,
    required this.imagemAsset,
    required this.avaliacao,
    required this.distancia,
    required this.categoria,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'especialidade': especialidade,
        'descricao': descricao,
        'imagemAsset': imagemAsset,
        'avaliacao': avaliacao,
        'distancia': distancia,
        'categoria': categoria,
      };

  factory Prestador.fromJson(Map<String, dynamic> json) => Prestador(
        nome: json['nome'] as String,
        especialidade: json['especialidade'] as String,
        descricao: json['descricao'] as String,
        imagemAsset: json['imagemAsset'] as String,
        avaliacao: (json['avaliacao'] as num).toDouble(),
        distancia: json['distancia'] as String,
        categoria: json['categoria'] as String,
      );
}
