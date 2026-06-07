import 'package:flutter/material.dart';
import '../components/app_header.dart';
import '../components/app_image.dart';
import '../core/app_colors.dart';
import '../models/prestador_model.dart';
import '../models/solicitacao_response.dart';

class OrcamentoPage extends StatelessWidget {
  final SolicitacaoResponse solicitacao;
  final Prestador prestador;

  const OrcamentoPage({
    super.key,
    required this.solicitacao,
    required this.prestador,
  });

  @override
  Widget build(BuildContext context) {
    final imagem = prestador.fotosUrls.isNotEmpty
        ? prestador.fotosUrls.first
        : prestador.imagemAsset;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E0A3C),
              Color(0xFF2D1B69),
              Color(0xFF1A1A3E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(
                  title: 'Solicitação Enviada',
                  emoji: '✅',
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.branco,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: AppImage(imagem),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prestador.nome,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  prestador.especialidade,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.destaque.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            solicitacao.status,
                            style: const TextStyle(
                              color: AppColors.principal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.principalEscura.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Descrição do serviço",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          solicitacao.descricao,
                          style: const TextStyle(
                            color: AppColors.branco,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              color: AppColors.destaque,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: AppColors.destaque,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Orçamento",
                            style: TextStyle(
                              color: AppColors.branco,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "Em andamento",
                            style: TextStyle(
                              color: AppColors.branco,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "Pagamento",
                            style: TextStyle(
                              color: AppColors.branco,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "Finalizado",
                            style: TextStyle(
                              color: AppColors.branco,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.branco,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                color: AppColors.preto.withOpacity(0.6),
                              ),
                            ),
                            const Text("A definir"),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Taxa Bicos",
                              style: TextStyle(
                                color: AppColors.preto.withOpacity(0.6),
                              ),
                            ),
                            const Text("A definir"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppColors.preto.withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total à pagar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "A definir",
                              style: TextStyle(
                                color: AppColors.principal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "ID da solicitação: #${solicitacao.id}",
                    style: TextStyle(
                      color: AppColors.branco.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
