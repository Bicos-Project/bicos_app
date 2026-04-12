import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: SizedBox(
        height: 65,
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
              top: 20,
              child: Image.asset(
                "assets/bicos_logo2.png",
                height: 30,
              ),
            ),

            Positioned(
              right: 16,
              top: 20,
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
    );
  }
}