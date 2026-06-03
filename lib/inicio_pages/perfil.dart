import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/avatar_service.dart';
import '../services/cliente_service.dart';
import '../models/cliente_model.dart';
import '../models/endereco_model.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _isLoading = true;
  bool _isSaving = false;
  ClienteResponse? _cliente;

  final _emailController = TextEditingController();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final auth = context.read<AuthProvider>();
    if (auth.userId == null) return;

    try {
      final cliente = await ClienteService.buscarPorId(auth.userId!);
      if (!mounted) return;
      setState(() {
        _cliente = cliente;
        _emailController.text = cliente.email;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar perfil: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _trocarAvatar() async {
    final file = await AvatarService.pickAndSave();
    if (file != null && mounted) {
      context.read<AuthProvider>().setAvatarPath(file.path);
    }
  }

  Future<void> _salvar() async {
    final auth = context.read<AuthProvider>();
    if (_cliente == null || auth.userId == null) return;

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _mostrarErro('E-mail não pode ficar vazio');
      return;
    }

    final senha = _senhaAtualController.text;
    if (senha.isEmpty) {
      _mostrarErro('Digite sua senha atual para confirmar as alterações');
      return;
    }

    final senhaFinal = _novaSenhaController.text.isNotEmpty
        ? _novaSenhaController.text
        : senha;

    setState(() => _isSaving = true);

    try {
      final request = ClienteCadastroRequest(
        nome: _cliente!.nome,
        email: email,
        cpf: _cliente!.cpf,
        senha: senhaFinal,
        telefone: _cliente!.telefone,
        endereco: _cliente!.endereco != null
            ? EnderecoRequest(
                cep: _cliente!.endereco!.cep,
                logradouro: _cliente!.endereco!.logradouro ?? '',
                numero: _cliente!.endereco!.numero,
                complemento: _cliente!.endereco!.complemento,
              )
            : null,
      );

      await ClienteService.atualizar(auth.userId!, request);

      if (!mounted) return;

      setState(() {
        _senhaAtualController.clear();
        _novaSenhaController.clear();
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _mostrarErro('Erro ao salvar: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.branco))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _construirCabecalho(auth),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: _trocarAvatar,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.destaque, width: 2),
                                  color: AppColors.principalEscura,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: auth.avatarPath != null
                                    ? ClipOval(
                                        child: Image.file(
                                          File(auth.avatarPath!),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.branco,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.destaque,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: AppColors.principalEscura,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _cliente?.nome ?? 'Usuário',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.branco,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _construirCampoLabel('E-mail'),
                        const SizedBox(height: 8),
                        _construirCampoTexto(
                          controller: _emailController,
                          dica: 'Digite seu e-mail',
                          icone: Icons.alternate_email,
                        ),
                        const SizedBox(height: 24),
                        _construirCampoLabel(
                            'Senha atual (obrigatório para salvar)'),
                        const SizedBox(height: 8),
                        _construirCampoTexto(
                          controller: _senhaAtualController,
                          dica: '••••••••••••',
                          icone: Icons.lock_outline,
                          esSenha: true,
                        ),
                        const SizedBox(height: 24),
                        _construirCampoLabel('Nova senha (opcional)'),
                        const SizedBox(height: 8),
                        _construirCampoTexto(
                          controller: _novaSenhaController,
                          dica: 'Deixe em branco para manter a atual',
                          icone: Icons.lock_outline,
                          esSenha: true,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _salvar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5A3A70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.branco,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Salvar alterações',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.branco,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _construirCabecalho(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('assets/bicos_logo1.png', height: 28),
            const SizedBox(width: 8),
            Text(
              'Bicos',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.destaque,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.principalEscura,
              ),
              clipBehavior: Clip.antiAlias,
              child: auth.avatarPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(auth.avatarPath!),
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person, size: 18, color: AppColors.branco),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: AppColors.branco, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _construirCampoLabel(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        texto,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.branco,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _construirCampoTexto({
    required TextEditingController controller,
    required String dica,
    required IconData icone,
    bool esSenha = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: esSenha,
      style: const TextStyle(color: AppColors.branco),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF262626),
        hintText: dica,
        hintStyle:
            TextStyle(color: AppColors.branco.withOpacity(0.4)),
        prefixIcon: Icon(icone, color: AppColors.branco.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
