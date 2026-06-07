import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../models/prestador_foto_model.dart';
import '../services/avatar_service.dart';
import '../services/cliente_service.dart';
import '../services/prestador_service.dart';
import '../models/cliente_model.dart';
import '../models/prestador_cadastro_request.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _isLoading = true;
  bool _isSaving = false;

  String? _nome;
  String? _cpf;
  String? _especialidade;
  List<PrestadorFoto> _fotos = [];
  File? _pickedAvatarFile;

  final _emailController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _descricaoController = TextEditingController();
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
    _especialidadeController.dispose();
    _descricaoController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  String _fullUrl(String relative) =>
      'http://localhost:8080$relative';

  Future<void> _carregarDados() async {
    final auth = context.read<AuthProvider>();
    if (auth.userId == null) return;

    try {
      if (auth.perfil == 'PRESTADOR') {
        final p = await PrestadorService.buscarPorId(auth.userId!);
        if (!mounted) return;
        setState(() {
          _nome = p.nome;
          _cpf = p.cpf;
          _emailController.text = p.email;
          _especialidade = p.especialidade;
          _especialidadeController.text = p.especialidade ?? '';
          _descricaoController.text = p.descricao ?? '';
          _fotos = List.from(p.fotos);
          _isLoading = false;
        });
        auth.setFotos(p.fotos);
      } else {
        final c = await ClienteService.buscarPorId(auth.userId!);
        if (!mounted) return;
        setState(() {
          _nome = c.nome;
          _cpf = c.cpf;
          _emailController.text = c.email;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _mostrarErro('Erro ao carregar perfil: $e');
    }
  }

  Future<void> _trocarAvatar() async {
    final file = await AvatarService.pickAndSave();
    if (file != null && mounted) {
      _pickedAvatarFile = file;
      context.read<AuthProvider>().setAvatarPath(file.path);
    }
  }

  Future<void> _adicionarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked == null || !mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.userId == null) return;

    try {
      final p = await PrestadorService.adicionarFoto(
          auth.userId!, File(picked.path));
      if (!mounted) return;
      setState(() => _fotos = List.from(p.fotos));
      auth.setFotos(p.fotos);
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao adicionar foto: $e');
    }
  }

  Future<void> _removerFoto(int index) async {
    final auth = context.read<AuthProvider>();
    if (auth.userId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cinza,
        title: const Text('Remover foto',
            style: TextStyle(color: AppColors.branco)),
        content: const Text('Tem certeza que deseja remover esta foto?',
            style: TextStyle(color: AppColors.branco)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.branco)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remover',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final p = await PrestadorService.removerFoto(
          auth.userId!, _fotos[index].id);
      if (!mounted) return;
      setState(() => _fotos = List.from(p.fotos));
      auth.setFotos(p.fotos);
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao remover foto: $e');
    }
  }

  Future<void> _salvar() async {
    final auth = context.read<AuthProvider>();
    if (_nome == null || auth.userId == null) return;

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
      if (auth.perfil == 'PRESTADOR') {
        final request = PrestadorCadastroRequest(
          nome: _nome!,
          email: email,
          cpf: _cpf ?? '',
          senha: senhaFinal,
          especialidade: _especialidadeController.text.trim(),
          descricao: _descricaoController.text.trim(),
        );
        await PrestadorService.atualizar(auth.userId!, request);
      } else {
        final request = ClienteCadastroRequest(
          nome: _nome!,
          email: email,
          cpf: _cpf ?? '',
          senha: senhaFinal,
        );
        await ClienteService.atualizar(auth.userId!, request);

        if (_pickedAvatarFile != null) {
          await ClienteService.atualizarFoto(
              auth.userId!, _pickedAvatarFile!);
          _pickedAvatarFile = null;
        }
      }

      if (!mounted) return;
      setState(() {
        _senhaAtualController.clear();
        _novaSenhaController.clear();
        _isSaving = false;
      });

      _mostrarSucesso('Perfil atualizado com sucesso!');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _mostrarErro(
          'Erro ao salvar: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
    );
  }

  void _mostrarSucesso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
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
                    final isPrestador = auth.perfil == 'PRESTADOR';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _construirCabecalho(auth),
                        const SizedBox(height: 24),
                        if (isPrestador) ...[
                          _construirSecaoFotos(),
                          const SizedBox(height: 24),
                        ] else ...[
                          _construirAvatar(auth),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          _nome ?? 'Usuário',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.branco,
                          ),
                        ),
                        if (isPrestador && _especialidade != null &&
                            _especialidade!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _especialidade!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.destaque,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        if (isPrestador) ...[
                          _construirCampoLabel('Especialidade'),
                          const SizedBox(height: 8),
                          _construirCampoTexto(
                            controller: _especialidadeController,
                            dica: 'Ex: ELETRICISTA, PINTORA...',
                            icone: Icons.work_outline,
                          ),
                          const SizedBox(height: 24),
                          _construirCampoLabel('Biografia'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descricaoController,
                            maxLines: 3,
                            style: const TextStyle(color: AppColors.branco),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF262626),
                              hintText: 'Conte um pouco sobre você...',
                              hintStyle: TextStyle(
                                  color: AppColors.branco.withOpacity(0.4)),
                              prefixIcon: Icon(Icons.description_outlined,
                                  color: AppColors.branco.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
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

  Widget _construirAvatar(AuthProvider auth) {
    return GestureDetector(
      onTap: _trocarAvatar,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.destaque, width: 2),
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
    );
  }

  Widget _construirSecaoFotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fotos do Serviço',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.branco,
              ),
            ),
            Text(
              'máx 3',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.branco.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < _fotos.length; i++) ...[
                _construirFotoCard(i),
                const SizedBox(width: 12),
              ],
              if (_fotos.length < 3) _construirAdicionarCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirFotoCard(int index) {
    final foto = _fotos[index];
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.principalEscura,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            _fullUrl(foto.url),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.destaque,
                  strokeWidth: 2,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, color: AppColors.branco, size: 40);
            },
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removerFoto(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: AppColors.branco),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirAdicionarCard() {
    return GestureDetector(
      onTap: _adicionarFoto,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.branco.withOpacity(0.3),
            width: 2,
          ),
          color: AppColors.principalEscura.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate,
                color: AppColors.branco.withOpacity(0.6), size: 32),
            const SizedBox(height: 4),
            Text(
              'Adicionar',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppColors.branco.withOpacity(0.6),
              ),
            ),
          ],
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
        hintStyle: TextStyle(color: AppColors.branco.withOpacity(0.4)),
        prefixIcon: Icon(icone, color: AppColors.branco.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
