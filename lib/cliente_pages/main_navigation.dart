import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_page.dart';
import 'favoritos_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const FavoritosPage(),
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.principal,

      body: pages[currentIndex],

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),

        child: Container(
          height: 75,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),

          child: Stack(
            children: [
              // 🔥 FUNDO (IMAGEM)
              Positioned.fill(
                child: Image.asset(
                  "assets/bottom.png",
                  fit: BoxFit.cover,
                ),
              ),

              // 🔥 NAVBAR POR CIMA
              BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },

                backgroundColor: Colors.transparent,
                elevation: 0,

                type: BottomNavigationBarType.fixed,

                selectedItemColor: AppColors.destaque,
                unselectedItemColor: Colors.white54,

                showSelectedLabels: true,
                showUnselectedLabels: true,

                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/coracao.png", width: 24),
                    label: "FAVORITOS",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/home.png", width: 24),
                    label: "HOME",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/menu.png", width: 24),
                    label: "MENU",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/historico.png", width: 24),
                    label: "HISTÓRICO",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}