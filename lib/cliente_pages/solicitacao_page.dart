import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../cliente_pages/orcamento_page.dart';

class SolicitacaoPage extends StatefulWidget {
  const SolicitacaoPage({super.key});

  @override
  State<SolicitacaoPage> createState() => _SolicitacaoPageState();
}

class _SolicitacaoPageState extends State<SolicitacaoPage> {
  int hoveredIndex = -1;

  Widget buildBotao(String texto, String? icon, int index) {
    bool isHovered = hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIndex = index),
      onExit: (_) => setState(() => hoveredIndex = -1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.principalEscura
              : AppColors.branco.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Image.asset(
                icon,
                height: 16,
                color: isHovered ? AppColors.branco : AppColors.preto,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              texto,
              style: TextStyle(
                color: isHovered ? AppColors.branco : AppColors.preto,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDateBox(String hint, int max) {
    return SizedBox(
      width: hint == "AAAA" ? 90 : 70,
      height: 45,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.branco,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: max,
          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                SizedBox(
                  height: 70,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/header.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 8,
                          top: 18,
                          child: IconButton(
                            icon: Image.asset(
                              "assets/seta_voltar.png",
                              height: 26,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Positioned.fill(
                          child: Center(
                            child: Text(
                              "Solicitar Serviço",
                              style: TextStyle(
                                color: AppColors.branco,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Preencha os detalhes abaixo que o prestador possa saber o que você precisa.",
                    style: TextStyle(
                      color: AppColors.branco.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "DESCRIÇÃO DO SERVIÇO",
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.branco.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      maxLines: 5,
                      style: TextStyle(color: AppColors.preto),
                      decoration: InputDecoration(
                        hintText:
                            "O que você precisa hoje? Descreva o trabalho...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // AGENDAMENTO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AGENDAMENTO",
                        style: TextStyle(
                          color: AppColors.branco,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset("assets/agenda.png", height: 22),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      buildDateBox("DD", 2),
                      const SizedBox(width: 6),
                      buildDateBox("MM", 2),
                      const SizedBox(width: 6),
                      buildDateBox("AAAA", 4),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // LOCALIZAÇÃO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "LOCALIZAÇÃO",
                        style: TextStyle(
                          color: AppColors.branco,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset("assets/localizacao.png", height: 22),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.branco.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      style: TextStyle(color: AppColors.preto),
                      decoration: InputDecoration(
                        hintText: "Endereço ou bairro",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // REFERÊNCIAS VISUAIS
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Referências Visuais",
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.principalEscura.withOpacity(
                        0.4,
                      ), // Ajustei opacidade para o gradiente brilhar por trás
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cinza.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Image.asset("assets/upload.png", height: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Toque para enviar imagens",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BOTÕES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildBotao("Urgente", "assets/reparos_rapidos.png", 0),
                        const SizedBox(width: 10),
                        buildBotao("Fim de semana", null, 1),
                        const SizedBox(width: 10),
                        buildBotao("Área Externa", null, 2),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BOTÃO FINAL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrcamentoPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors
                            .destaque, 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Pedir Orçamento",
                            style: TextStyle(
                              color: AppColors
                                  .preto, 
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            "assets/seta_avancar.png",
                            height: 18,
                            color: AppColors.preto,
                          ),
                        ],
                      ),
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
