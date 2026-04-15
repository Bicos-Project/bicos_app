import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'solicitacao_page.dart';
import 'favoritos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> categorias = const [
    {"nome": "Beleza e Estética", "imagem": "assets/beleza.png"},
    {"nome": "Serviços Domésticos", "imagem": "assets/servicos_domesticos.png"},
    {"nome": "Reparos Rápidos", "imagem": "assets/reparos_rapidos.png"},
    {"nome": "Alimentação", "imagem": "assets/alimentacao.png"},
    {"nome": "Obras e Reformas", "imagem": "assets/obras.png"},
    {"nome": "Logística Local", "imagem": "assets/logistica.png"},
    {"nome": "Manutenção Eletrônica", "imagem": "assets/eletronica.png"},
    {"nome": "Cuidadores", "imagem": "assets/cuidadores.png"},
  ];

  final List<Map<String, String>> favoritos = const [
    {
      "nome": "Josefino Barros",
      "imagem": "assets/eletricista.png",
      "categoria": "Eletricista",
    },
    {
      "nome": "Carlos Telles",
      "imagem": "assets/pedreiro.png",
      "categoria": "Pedreiro",
    },
    {
      "nome": "Ana Graças",
      "imagem": "assets/cabeleireira.png",
      "categoria": "Cabeleireira",
    },
    {
      "nome": "Judite Anésio",
      "imagem": "assets/trancista.png",
      "categoria": "Trancista",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
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

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Olá, Usuário",
                  style: TextStyle(
                    color: AppColors.branco,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 11),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Encontre serviços próximos a você",
                  style: TextStyle(
                    color: AppColors.branco.withOpacity(0.8),
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 11),

              // GRID CATEGORIAS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categorias.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.0,
                  ),
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 23,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.branco,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            categoria["imagem"]!,
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              categoria["nome"]!,
                              style: const TextStyle(
                                color: AppColors.principal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/coracao.png",
                          width: 20,
                          color: AppColors.destaque,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Favoritos",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritosPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "Ver todos",
                            style: TextStyle(color: AppColors.destaque),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            "assets/seta_avancar.png",
                            width: 14,
                            color: AppColors.destaque,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // LISTA FAVORITOS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: favoritos.map((fav) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SolicitacaoPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          height: 96,
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
                                      fav["imagem"]!,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fav["nome"]!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        fav["categoria"]!,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Image.asset("assets/coracao.png", width: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
