import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/cliente_service.dart';
import '../services/prestador_service.dart';
import '../models/cliente_model.dart';
import '../models/prestador_cadastro_request.dart';
import '../components/main_navigation_cliente.dart';
import '../components/main_navigation_prestador.dart';

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
          _isLoading = false;
        });
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
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.principalEscura,
                          child: Text(
                            _nome != null && _nome!.isNotEmpty
                                ? _nome![0].toUpperCase()
                                : '?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.destaque,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                            dica: 'Ex: Pedreiro, Encanador...',
                            icone: Icons.work_outline,
                          ),
                          const SizedBox(height: 24),
                          _construirCampoLabel('Descrição'),
                          const SizedBox(height: 8),
                          _construirCampoTexto(
                            controller: _descricaoController,
                            dica: 'Fale um pouco sobre seu trabalho',
                            icone: Icons.description_outlined,
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

  Widget _construirCabecalho(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.branco,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (auth.perfil == 'PRESTADOR') {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MainNavigationPrestador()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MainNavigation()),
                      (route) => false,
                    );
                  }
                },
                child: Row(
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
              ),
            ),
          ],
        ),
        Text(
          'Perfil',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.branco,
          ),
        ),
      ],
    );
  }

  Widget _construirCampoLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.branco.withOpacity(0.7),
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
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppColors.branco,
      ),
      decoration: InputDecoration(
        hintText: dica,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.branco.withOpacity(0.3),
        ),
        prefixIcon: Icon(icone, color: AppColors.destaque, size: 20),
        filled: true,
        fillColor: AppColors.branco.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.branco.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.destaque, width: 1.5),
        ),
      ),
    );
  }
}
