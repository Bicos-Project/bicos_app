import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class ServiceCard extends StatelessWidget {
  final String titulo;
  final String imagem;

  const ServiceCard({
    super.key,
    required this.titulo,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.principal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(imagem, width: 50),
          SizedBox(width: 12),
          Text(titulo, style: AppTextStyles.textoPadrao),
          Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
        ],
      ),
    );
  }
}