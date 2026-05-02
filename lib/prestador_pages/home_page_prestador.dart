import 'package:bicos_app/core/app_colors.dart';
import 'package:bicos_app/prestador_pages/visualizacao_proposta_prestador.dart';
import 'package:flutter/material.dart';
import 'package:bicos_app/prestador_pages/ver_mais_solicitacoes.dart';


class HomePagePrestador extends StatefulWidget {
  const HomePagePrestador({super.key, required this.title});
  final String title;

  @override
  State<HomePagePrestador> createState() => _HomePagePrestadorState();
}

class _HomePagePrestadorState extends State<HomePagePrestador> {
  // Simulação de dados das solicitações
  final List<Map<String, String>> solicitacoes = [
    {
      "nome": "Ana Paula Silva",
      "servico": "Troca de cabos",
      "horario": "09:00",
    },
    {
      "nome": "Vera Azevedo",
      "servico": "Ajuste de chuveiro",
      "horario": "09:00",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.principal,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _construirHeader(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá, Usuário!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Veja como andam os seus bicos.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Card de Avaliação (Verde limão)
              _buildRatingCard(),

              const SizedBox(height: 32),
              _buildSectionTitle('Solicitações recebidas', '2 novas'),
              const SizedBox(height: 16),

              // Lista de Solicitações
              ...solicitacoes.map((s) => _buildSolicitacaoCard(s)).toList(),
              _buildVerMaisSolicitacoesButton(),
              const SizedBox(height: 20),
              _buildSectionTitle('Serviços em andamento', '1 em progresso'),
              const SizedBox(height: 24),
              _buildJobStatusCard(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _construirHeader() {
    return Stack(
      children: [
        Image.asset('assets/header.png', fit: BoxFit.fill),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/bicos_logo2.png', height: 32),
                Container(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: Image.asset('assets/perfil.png', fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF481),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.stars, color: Color(0xFF5C2B67), size: 20),
              SizedBox(width: 8),
              Text(
                'AVALIAÇÃO',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Text(
            '4.9',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.destaque,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: const TextStyle(color: AppColors.cinza, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildSolicitacaoCard(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Colors.grey, radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['nome']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${data['servico']} • 4h • Amanhã às ${data['horario']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisualizacaoPropostaPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.branco,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text('Visualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerMaisSolicitacoesButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 95,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            // Lógica para ver mais detalhes do serviço em andamento
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerMaisSolicitacoesPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.principal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: AppColors.destaque, width: 2),
            ),
          ),
          child: const Text(
            'Ver Mais',
            style: TextStyle(color: AppColors.destaque, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildJobStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manutenção Elétrica',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Cliente: Marcos Oliveira • R. das Palmeiras, 452',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFFDFF481),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

}
