import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/avatar_service.dart';
import '../prestador_pages/editar_perfil_publico.dart';
import 'perfil.dart';
import 'escolha_perfil.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  Future<void> _pickAvatar(BuildContext context) async {
    final file = await AvatarService.pickAndSave();
    if (file != null && context.mounted) {
      context.read<AuthProvider>().setAvatarPath(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/bicos_logo1.png', height: 32),
                  const SizedBox(width: 8),
                  Text(
                    'Bicos',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.destaque,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: AppColors.branco.withOpacity(0.15), thickness: 1),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return GestureDetector(
                    onTap: () => _pickAvatar(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF46295C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.branco.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.destaque,
                                    width: 1.5,
                                  ),
                                  color: AppColors.principalEscura,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: auth.avatarPath != null
                                    ? ClipOval(
                                        child: Image.file(
                                          File(auth.avatarPath!),
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppColors.branco,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppColors.destaque,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: AppColors.principalEscura,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth.nome ?? 'Usuário',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.branco,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  auth.email ?? '',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        AppColors.branco.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              _construirBotaoMenu(
                icone: Icons.account_circle_outlined,
                titulo: 'Perfil',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PerfilPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  if (auth.perfil != 'PRESTADOR') {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      _construirBotaoMenu(
                        icone: Icons.edit_outlined,
                        titulo: 'Editar Perfil Público',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EditarPerfilPublicoPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              _construirBotaoMenu(
                icone: Icons.settings_outlined,
                titulo: 'Configurações',
                onTap: () {
                  // Configurações
                },
              ),
              const SizedBox(height: 16),
              _construirBotaoMenu(
                icone: Icons.logout_outlined,
                titulo: 'Sair',
                ehSair: true,
                onTap: () {
                  context.read<AuthProvider>().logOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EscolhaPerfil()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirBotaoMenu({
    required IconData icone,
    required String titulo,
    required VoidCallback onTap,
    bool ehSair = false,
  }) {
    final corFundo =
        ehSair ? const Color(0xFF6B2745) : const Color(0xFF46295C);
    final corBorda =
        ehSair ? Colors.transparent : AppColors.branco.withOpacity(0.1);
    final corIcone =
        ehSair ? const Color(0xFFFF9EAA) : AppColors.destaque;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: corBorda),
        ),
        child: Row(
          children: [
            Icon(icone, color: corIcone, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.branco,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.branco.withOpacity(0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
