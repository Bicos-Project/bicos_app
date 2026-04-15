import 'package:bicos_app/cliente_pages/avaliacao.dart';
import 'package:bicos_app/cliente_pages/chat_cliente.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class OrcamentoPage extends StatelessWidget {
  const OrcamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.2,
            colors: [Color(0xFF4A1060), Color(0xFF3B0A52), AppColors.principal],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  child: SizedBox(
                    height: 90,
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/header.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 16,
                          top: 30,
                          child: Image.asset(
                            "assets/bicos_logo2.png",
                            height: 30,
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/perfil.png",
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: Image.asset("assets/seta_voltar.png", height: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

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
                              child: Image.asset(
                                "assets/eletricista.png",
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Josefino Barros",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Eletricista",
                                  style: TextStyle(color: Colors.black54),
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
                          child: const Text(
                            "Enviado",
                            style: TextStyle(
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
                      color: AppColors.principalEscura.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "R\$ __ , __",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                            const Text("R\$ 000,00"),
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
                            const Text("R\$ 15,00"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppColors.preto.withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total à pagar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "R\$ 00,00",
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

                const SizedBox(height: 30),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatClientePage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Center(
                        child: Image.asset("assets/conversa.png", width: 32),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "Já realizou o pagamento?",
                    style: TextStyle(color: AppColors.branco.withOpacity(0.8)),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AvaliacaoServico(),
                        ),
                      );
   
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.destaque,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Confirmar Pagamento",
                          style: TextStyle(
                            color: AppColors.preto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

      
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.branco.withOpacity(0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Algo de errado? Fale conosco",
                        style: TextStyle(
                          color: AppColors.branco.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
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
