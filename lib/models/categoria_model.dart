class Categoria {
  final int id;
  final String nome;
  final String? descricao;

  Categoria({required this.id, required this.nome, this.descricao});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
    );
  }

  String get assetName {
    final map = {
      'Beleza e Estética': 'assets/beleza.png',
      'Serviços Domésticos': 'assets/servicos_domesticos.png',
      'Reparos Rápidos': 'assets/reparos_rapidos.png',
      'Alimentação': 'assets/alimentacao.png',
      'Obras e Reformas': 'assets/obras.png',
      'Logística Local': 'assets/logistica.png',
      'Manutenção Eletrônica': 'assets/eletronica.png',
      'Cuidadores': 'assets/cuidadores.png',
    };
    return map[nome] ?? 'assets/busca.png';
  }
}
