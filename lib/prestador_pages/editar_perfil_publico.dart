import 'dart:io';
import 'package:bicos_app/components/app_header.dart';
import 'package:bicos_app/core/app_colors.dart';
import 'package:bicos_app/models/categoria_model.dart';
import 'package:bicos_app/models/prestador_cadastro_request.dart';
import 'package:bicos_app/models/prestador_foto_model.dart';
import 'package:bicos_app/providers/auth_provider.dart';
import 'package:bicos_app/services/api_client.dart';
import 'package:bicos_app/services/categoria_service.dart';
import 'package:bicos_app/services/prestador_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bicos_app/components/main_navigation_prestador.dart';

class EditarPerfilPublicoPage extends StatefulWidget {
  const EditarPerfilPublicoPage({super.key});

  @override
  State<EditarPerfilPublicoPage> createState() => _EditarPerfilPublicoPageState();
}

class _EditarPerfilPublicoPageState extends State<EditarPerfilPublicoPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _descricaoController = TextEditingController();
  int? _categoriaSelecionada;
  List<Categoria> _categorias = [];
  List<PrestadorFoto> _fotos = [];
  bool _isLoading = true;
  bool _isSaving = false;
  int? _prestadorId;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      _prestadorId = auth.userId;

      final categorias = await CategoriaService.listar();
      final prestador = await PrestadorService.buscarPorId(auth.userId!);

      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _fotos = List.from(prestador.fotos);
        _nomeController.text = prestador.nome;
        _emailController.text = prestador.email;
        _especialidadeController.text = prestador.especialidade ?? '';
        _descricaoController.text = prestador.descricao ?? '';
        _categoriaSelecionada = prestador.categoria?['id'] as int?;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _mostrarSnack('Erro ao carregar dados do perfil');
    }
  }

  String _fullUrl(String relative) =>
      '${ApiClient.getBaseUrl()}$relative';

  Future<void> _adicionarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked == null || !mounted || _prestadorId == null) return;

    try {
      final p = await PrestadorService.adicionarFoto(
          _prestadorId!, File(picked.path));
      if (!mounted) return;
      setState(() => _fotos = List.from(p.fotos));
    } catch (_) {
      if (mounted) _mostrarSnack('Erro ao adicionar foto');
    }
  }

  Future<void> _removerFoto(int index) async {
    if (_prestadorId == null) return;

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
          _prestadorId!, _fotos[index].id);
      if (!mounted) return;
      setState(() => _fotos = List.from(p.fotos));
    } catch (_) {
      if (mounted) _mostrarSnack('Erro ao remover foto');
    }
  }

  Future<void> _salvar() async {
    if (_prestadorId == null) return;

    setState(() => _isSaving = true);
    try {
      final request = PrestadorCadastroRequest(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        cpf: '',
        senha: '',
        descricao: _descricaoController.text.trim(),
        especialidade: _especialidadeController.text.trim(),
        categoriaId: _categoriaSelecionada,
      );

      await PrestadorService.atualizar(_prestadorId!, request);

      if (!mounted) return;
      _mostrarSnack('Perfil atualizado com sucesso!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPrestador()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack('Erro ao salvar perfil');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.principalEscura),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.cinza, fontSize: 14),
      filled: true,
      fillColor: AppColors.branco,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _especialidadeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: const AppHeader(showAvatar: true),
      ),
      backgroundColor: AppColors.principal,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.destaque))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'EDITAR PERFIL PÚBLICO',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Atualize as informações\nque os clientes veem.',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('NOME',
                      style: TextStyle(color: AppColors.branco, fontSize: 11)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nomeController,
                    decoration: _inputStyle('Seu nome'),
                  ),
                  const SizedBox(height: 16),
                  const Text('E-MAIL',
                      style: TextStyle(color: AppColors.branco, fontSize: 11)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: _inputStyle('Seu e-mail'),
                  ),
                  const SizedBox(height: 16),
                  const Text('ESPECIALIDADE',
                      style: TextStyle(color: AppColors.branco, fontSize: 11)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _especialidadeController,
                    decoration: _inputStyle('Ex: Eletricista, Pintor...'),
                  ),
                  const SizedBox(height: 20),
                  const Text('CATEGORIA',
                      style: TextStyle(color: AppColors.branco, fontSize: 11)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categorias.map((c) {
                      final selected = _categoriaSelecionada == c.id;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _categoriaSelecionada = c.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.destaque
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            c.nome,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.principalEscura
                                  : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('DESCRIÇÃO',
                      style: TextStyle(color: AppColors.branco, fontSize: 11)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descricaoController,
                    maxLines: 4,
                    decoration: _inputStyle(
                        'Conte um pouco sobre seu trabalho...'),
                  ),
                  const SizedBox(height: 24),
                  _buildFotosSection(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDFF481),
                        foregroundColor: const Color(0xFF425F23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF425F23),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Salvar Perfil',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.save_outlined, size: 18),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
    );
  }

  Widget _buildFotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('FOTOS DO SERVIÇO',
                style: TextStyle(color: AppColors.branco, fontSize: 11)),
            Text(
              'máx 3',
              style: TextStyle(
                color: AppColors.branco.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              for (int i = 0; i < _fotos.length; i++) ...[
                _buildFotoCard(i),
                const SizedBox(width: 12),
              ],
              if (_fotos.length < 3) _buildAdicionarCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFotoCard(int index) {
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
              return const Icon(Icons.image,
                  color: AppColors.branco, size: 40);
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
              child: const Icon(Icons.close,
                  size: 14, color: AppColors.branco),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdicionarCard() {
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
              style: TextStyle(
                color: AppColors.branco.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
