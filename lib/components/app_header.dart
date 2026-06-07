import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import 'main_navigation_cliente.dart';
import 'main_navigation_prestador.dart';

class AppHeader extends StatelessWidget {
  final bool showBack;
  final String? title;
  final String? emoji;
  final Widget? trailing;
  final bool showAvatar;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;

  const AppHeader({
    super.key,
    this.showBack = false,
    this.title,
    this.emoji,
    this.trailing,
    this.showAvatar = false,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
  });

  void _goHome(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.perfil == 'PRESTADOR') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPrestador()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSearch = searchController != null;

    return SizedBox(
      height: 76,
      child: Stack(
        children: [
          Image.asset('assets/header.png', width: double.infinity, height: 76, fit: BoxFit.cover),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: isSearch ? 12 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showBack)
                    _backButton(context)
                  else
                    _logo(context),
                  if (emoji != null && title != null) ...[
                    const SizedBox(width: 10),
                    Text(emoji!, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        title!,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.destaque,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ] else if (title != null) ...[
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        title!,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.destaque,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                  if (isSearch) ...[
                    const SizedBox(width: 12),
                    Expanded(child: _searchField()),
                  ],
                  const Spacer(),
                  if (showAvatar)
                    _avatar()
                  else if (trailing != null)
                    trailing!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _goHome(context),
        child: Image.asset('assets/bicos_logo2.png', height: 32),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_new, color: AppColors.branco, size: 20),
      ),
    );
  }

  Widget _avatar() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.principalEscura,
          ),
          clipBehavior: Clip.antiAlias,
          child: auth.avatarPath != null
              ? ClipOval(
                  child: Image.file(
                    File(auth.avatarPath!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.person, size: 24, color: AppColors.branco),
        );
      },
    );
  }

  Widget _searchField() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.branco.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.branco.withOpacity(0.15)),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        textInputAction: TextInputAction.search,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.branco,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: searchHint ?? 'Buscar serviço ou profissional...',
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.branco.withOpacity(0.4),
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.branco.withOpacity(0.5), size: 20),
          suffixIcon: searchController!.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchController!.clear();
                    onSearchChanged?.call('');
                  },
                  child: Icon(Icons.close, color: AppColors.branco.withOpacity(0.5), size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
