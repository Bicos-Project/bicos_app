import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle tituloGigante = GoogleFonts.plusJakartaSans(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.8,

    height: 1.0,
    color: AppColors.branco,
  );

  static TextStyle textoPadrao = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.branco,
  );
}
