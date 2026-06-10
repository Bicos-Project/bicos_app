import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  String _fullUrl(String relative) => 'http://localhost:8080$relative';

  @override
  Widget build(BuildContext context) {
    if (src.isEmpty) {
      return _fallback();
    }

    if (src.startsWith('/')) {
      return Image.network(
        _fullUrl(src),
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.destaque,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      src,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    final iconSize = (width ?? 64) < 40 ? 24.0 : (width ?? 64) < 60 ? 32.0 : 64.0;
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFD2C3D9),
      child: Icon(
        Icons.person,
        size: iconSize,
        color: AppColors.principalEscura,
      ),
    );
  }
}
