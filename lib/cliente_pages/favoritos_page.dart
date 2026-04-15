import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'solicitacao_page.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final List<Map<String, String>> favoritos = [
    {
      "nome": "Josefino Barros",
      "imagem": "assets/eletricista.png",
      "servico": "Eletricista",
      "tipo": "Obras",
    },
    {
      "nome": "Carlos Telles",
      "imagem": "assets/pedreiro.png",
      "servico": "Pedreiro",
      "tipo": "Obras",
    },
    {
      "nome": "Ana Graças",
      "imagem": "assets/cabeleireira.png",
      "servico": "Cabeleireira",
      "tipo": "Beleza",
    },
    {
      "nome": "Judite Anésio",
      "imagem": "assets/trancista.png",
      "servico": "Trancista",
      "tipo": "Beleza",
    },
    {
      "nome": "Carlos Silva",
      "imagem": "assets/troca_gas.png",
      "servico": "Troca de gás",
      "tipo": "Domesticos",
    },
    {
      "nome": "Rose Bueno",
      "imagem": "assets/diarista.png",
      "servico": "Diarista",
      "tipo": "Domesticos",
    },
  ];

  Widget buildCategoria(
    String titulo,
    String icon,
    List<Map<String, String>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷️ título categoria (PNG branco)
        Row(
          children: [
            Image.asset(
              icon,
              width: 27,
              height: 25,
              color: AppColors.branco,
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(
                color: AppColors.branco,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 📌 itens
        ...items.map((item) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SolicitacaoPage(),
                  ),
                );
              },

              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item["imagem"]!,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(item["nome"]!),
              subtitle: Text(item["servico"]!),

              trailing: IconButton(
                icon: Image.asset("assets/coracao.png", height: 22),
                onPressed: () {},
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> obras = favoritos
        .where((e) => e["tipo"] == "Obras")
        .toList();

    List<Map<String, String>> beleza = favoritos
        .where((e) => e["tipo"] == "Beleza")
        .toList();

    List<Map<String, String>> domesticos = favoritos
        .where((e) => e["tipo"] == "Domesticos")
        .toList();

    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔥 HEADER
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

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        "assets/seta_voltar.png",
                        height: 22,
                        color: AppColors.branco,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/coracao.png",
                            height: 22,
                            color: AppColors.destaque,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Seus favoritos",
                            style: TextStyle(
                              color: AppColors.branco,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    buildCategoria(
                      "Obras e Reformas",
                      "assets/obras.png",
                      obras,
                    ),
                    buildCategoria(
                      "Beleza e Estética",
                      "assets/beleza.png",
                      beleza,
                    ),
                    buildCategoria(
                      "Serviços Domésticos",
                      "assets/servicos_domesticos.png",
                      domesticos,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
