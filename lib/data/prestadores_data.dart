import '../models/prestador_model.dart';

List<Prestador> prestadoresDaCategoria(String categoria) {
  final map = <String, List<Prestador>>{
    'Beleza e Estética': [
      const Prestador(
        nome: 'Ana Graças',
        especialidade: 'CABELEIREIRA',
        descricao: 'Especialista em cortes, coloração e penteados femininos e masculinos.',
        imagemAsset: 'assets/cabeleireira.png',
        avaliacao: 4.7,
        distancia: '1,5 km',
        categoria: 'Beleza e Estética',
      ),
      const Prestador(
        nome: 'Judite Anésio',
        especialidade: 'TRANÇISTA',
        descricao: 'Trancista profissional com mais de 8 anos de experiência.',
        imagemAsset: 'assets/trancista.png',
        avaliacao: 4.9,
        distancia: '3 km',
        categoria: 'Beleza e Estética',
      ),
      const Prestador(
        nome: 'Marina Costa',
        especialidade: 'MAQUIADORA',
        descricao: 'Maquiagem profissional para festas, casamentos e eventos.',
        imagemAsset: 'assets/beleza.png',
        avaliacao: 4.5,
        distancia: '2,1 km',
        categoria: 'Beleza e Estética',
      ),
    ],
    'Serviços Domésticos': [
      const Prestador(
        nome: 'Rose Bueno',
        especialidade: 'DIARISTA',
        descricao: 'Limpeza pesada e organização residencial com mais de 10 anos.',
        imagemAsset: 'assets/diarista.png',
        avaliacao: 4.8,
        distancia: '1 km',
        categoria: 'Serviços Domésticos',
      ),
      const Prestador(
        nome: 'Carlos Silva',
        especialidade: 'TROCA DE GÁS',
        descricao: 'Entrega e instalação de gás de cozinha com agilidade.',
        imagemAsset: 'assets/troca_gas.png',
        avaliacao: 4.6,
        distancia: '2,5 km',
        categoria: 'Serviços Domésticos',
      ),
    ],
    'Reparos Rápidos': [
      const Prestador(
        nome: 'Josefino Barros',
        especialidade: 'ELETRICISTA',
        descricao: 'Instalações e reparos elétricos residenciais e comerciais.',
        imagemAsset: 'assets/eletricista.png',
        avaliacao: 4.8,
        distancia: '1,2 km',
        categoria: 'Reparos Rápidos',
      ),
      const Prestador(
        nome: 'Luis Carlos',
        especialidade: 'BOMBEIRO HIDRÁULICO',
        descricao: 'Conserto de vazamentos, troca de torneiras e desentupimento.',
        imagemAsset: 'assets/reparos_rapidos.png',
        avaliacao: 4.4,
        distancia: '3 km',
        categoria: 'Reparos Rápidos',
      ),
    ],
    'Alimentação': [
      const Prestador(
        nome: 'Dona Rosa',
        especialidade: 'COZINHEIRA',
        descricao: 'Refeições caseiras, marmitas e buffet para eventos.',
        imagemAsset: 'assets/alimentacao.png',
        avaliacao: 4.9,
        distancia: '1,8 km',
        categoria: 'Alimentação',
      ),
      const Prestador(
        nome: 'Chef Marcos',
        especialidade: 'CHEF PARTICULAR',
        descricao: 'Chef profissional para jantares e eventos especiais.',
        imagemAsset: 'assets/barbeiro.png',
        avaliacao: 4.7,
        distancia: '4 km',
        categoria: 'Alimentação',
      ),
    ],
    'Obras e Reformas': [
      const Prestador(
        nome: 'Elisa Nunes',
        especialidade: 'PINTORA',
        descricao: 'Realizo pinturas há mais de 15 anos. Pinto paredes e pisos.',
        imagemAsset: 'assets/pintora.png',
        avaliacao: 4.1,
        distancia: '2 km',
        categoria: 'Obras e Reformas',
      ),
      const Prestador(
        nome: 'Josefino Barros',
        especialidade: 'ELETRICISTA',
        descricao: 'Especialista em instalações residenciais e manutenção preventiva.',
        imagemAsset: 'assets/eletricista.png',
        avaliacao: 4.8,
        distancia: '1,2 km',
        categoria: 'Obras e Reformas',
      ),
      const Prestador(
        nome: 'Carlos Silva',
        especialidade: 'CONSTRUTOR',
        descricao: 'Construção e reforma civil com equipe especializada.',
        imagemAsset: 'assets/pedreiro.png',
        avaliacao: 4.6,
        distancia: '3 km',
        categoria: 'Obras e Reformas',
      ),
    ],
    'Logística Local': [
      const Prestador(
        nome: 'Pedro Santos',
        especialidade: 'ENTREGADOR',
        descricao: 'Entregas rápidas de documentos, alimentos e pequenos pacotes.',
        imagemAsset: 'assets/logistica.png',
        avaliacao: 4.5,
        distancia: '1 km',
        categoria: 'Logística Local',
      ),
      const Prestador(
        nome: 'Moto Express',
        especialidade: 'FRETISTA',
        descricao: 'Transporte de mercadorias e mudanças pequenas.',
        imagemAsset: 'assets/trabalhador.png',
        avaliacao: 4.3,
        distancia: '2 km',
        categoria: 'Logística Local',
      ),
    ],
    'Manutenção Eletrônica': [
      const Prestador(
        nome: 'Tech João',
        especialidade: 'TÉCNICO EM ELETRÔNICA',
        descricao: 'Conserto de celulares, notebooks, tablets e videogames.',
        imagemAsset: 'assets/eletronica.png',
        avaliacao: 4.7,
        distancia: '2,5 km',
        categoria: 'Manutenção Eletrônica',
      ),
      const Prestador(
        nome: 'Maria Clara',
        especialidade: 'TÉCNICA EM INFORMÁTICA',
        descricao: 'Manutenção de computadores, formatação e redes.',
        imagemAsset: 'assets/reparos_rapidos.png',
        avaliacao: 4.8,
        distancia: '3 km',
        categoria: 'Manutenção Eletrônica',
      ),
    ],
    'Cuidadores': [
      const Prestador(
        nome: 'Sônia Santos',
        especialidade: 'CUIDADORA DE IDOSOS',
        descricao: 'Cuidados com idosos, administração de medicamentos e acompanhamento.',
        imagemAsset: 'assets/cuidadores.png',
        avaliacao: 5.0,
        distancia: '1,5 km',
        categoria: 'Cuidadores',
      ),
      const Prestador(
        nome: 'Tia Fátima',
        especialidade: 'BABÁ',
        descricao: 'Cuido de crianças com muito carinho e responsabilidade.',
        imagemAsset: 'assets/diarista.png',
        avaliacao: 4.9,
        distancia: '2 km',
        categoria: 'Cuidadores',
      ),
    ],
  };
  return map[categoria] ?? [
    const Prestador(
      nome: 'Profissional Disponível',
      especialidade: 'GERAL',
      descricao: 'Profissional pronto para atender sua necessidade.',
      imagemAsset: 'assets/trabalhador.png',
      avaliacao: 4.5,
      distancia: '2 km',
      categoria: 'Geral',
    ),
  ];
}

List<Prestador> todosPrestadores() {
  final categorias = [
    'Beleza e Estética',
    'Serviços Domésticos',
    'Reparos Rápidos',
    'Alimentação',
    'Obras e Reformas',
    'Logística Local',
    'Manutenção Eletrônica',
    'Cuidadores',
  ];
  return categorias.expand((c) => prestadoresDaCategoria(c)).toList();
}
