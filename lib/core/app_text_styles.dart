import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; 

class AppTextStyles {
  // Esse é o estilo exato que você mandou do Figma
  static TextStyle tituloGigante = GoogleFonts.plusJakartaSans(
    fontSize: 56,
    fontWeight: FontWeight.w800, // 800 equivale ao ExtraBold
    letterSpacing: -2.8,
    // No Flutter, a altura da linha (height) é um multiplicador do tamanho da fonte.
    // Como no Figma o size é 56 e o line-height também é 56, a proporção é 1.0.
    height: 1.0, 
    color: AppColors.branco, // Coloquei branco por padrão, mas você pode mudar
  );

  // Exemplo de como você pode ir adicionando outras variações depois:
  static TextStyle textoPadrao = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.branco,
  );
}