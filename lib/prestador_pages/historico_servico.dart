import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/prestador_pages/andamento_servico.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class HistoricoServicoRealizadoPage extends StatelessWidget {
  const HistoricoServicoRealizadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista simulada de dados baseada no seu print
    final List<Map<String, dynamic>> historico = [
      {
        "nome": "Vera Azevedo",
        "servico": "Ajuste de chuveiro",
        "data": "06/04/2026",
        "status": "Em andamento",
        "corStatus": Colors.amber,
      },
      {
        "nome": "Clarisse",
        "servico": "Instalação hidráulica da cozinha",
        "data": "21/03/2026",
        "status": "Esperando pagamento",
        "corStatus": Colors.orange,
      },
      {
        "nome": "Juliana Souza",
        "servico": "Ajuste de chuveiro",
        "data": "05/02/2026",
        "status": "Finalizado",
        "corStatus": Colors.green,
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(showAvatar: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de serviços',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.branco,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Gerador da lista de cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historico.length,
              itemBuilder: (context, index) {
                final item = historico[index];
                return _buildHistoricoCard(context, item);
              },
            ),
            const SizedBox(height: 100), // Espaço para não cobrir o nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de Perfil
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              // Informações do Serviço
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['nome'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.principalEscura,
                          ),
                        ),
                        // Status Pill
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: item['corStatus'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['status'],
                              style: TextStyle(
                                color: item['corStatus'],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['servico'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['data'],
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Botão Visualizar
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 100,
              height: 35,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AndamentoServicoPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.principal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Visualizar',
                  style: TextStyle(
                    color: AppColors.principal,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
