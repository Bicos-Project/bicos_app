import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../components/main_navigation_prestador.dart';
import '../models/prestador_cadastro_request.dart';
import '../models/endereco_model.dart';
import '../services/prestador_service.dart';
import '../providers/auth_provider.dart';
import 'login_prestador.dart';

class CadastroPrestadorPage extends StatefulWidget {
  const CadastroPrestadorPage({super.key});

  @override
  State<CadastroPrestadorPage> createState() => _CadastroPrestadorPageState();
}

class _CadastroPrestadorPageState extends State<CadastroPrestadorPage> {
  bool _senhaOculta = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _descricaoController.dispose();
    _especialidadeController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = PrestadorCadastroRequest(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        cpf: _cpfController.text.trim(),
        senha: _senhaController.text,
        descricao: _descricaoController.text.trim(),
        especialidade: _especialidadeController.text.trim(),
        endereco: EnderecoRequest(
          cep: _cepController.text.trim(),
          logradouro: _logradouroController.text.trim(),
          numero: _numeroController.text.trim(),
          complemento: _complementoController.text.trim(),
        ),
      );

      await PrestadorService.cadastrar(request);

      if (!mounted) return;

      context.read<AuthProvider>().clearError();
      await context
          .read<AuthProvider>()
          .loginPrestador(_emailController.text.trim(), _senhaController.text);

      if (!mounted) return;

      if (context.read<AuthProvider>().isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPrestador()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().contains('DioException')
          ? 'Erro ao cadastrar. Verifique os dados e tente novamente.'
          : e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/bicos_logo1.png', height: 60),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        color: AppColors.branco,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      children: [
                        const TextSpan(text: 'Bem vindo\nao '),
                        TextSpan(
                          text: 'Bicos',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(text: '!'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _construirLabel('Nome'),
                  _construirCampoTexto(
                    dica: 'Digite seu nome',
                    icone: Icons.person_outline,
                    controller: _nomeController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Nome obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('E-mail'),
                  _construirCampoTexto(
                    dica: 'Digite seu e-mail',
                    icone: Icons.alternate_email,
                    controller: _emailController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'E-mail obrigatório';
                      if (!v.contains('@')) return 'E-mail inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('CPF'),
                  _construirCampoTexto(
                    dica: 'Ex: 000.000.000-00',
                    icone: Icons.person_outline,
                    controller: _cpfController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'CPF obrigatório';
                      final digits = v.replaceAll(RegExp(r'\D'), '');
                      if (digits.length != 11) return 'CPF deve ter 11 dígitos';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('Senha'),
                  _construirCampoTexto(
                    dica: '••••••••••••',
                    icone: Icons.lock_outline,
                    esSenha: true,
                    controller: _senhaController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Senha obrigatória';
                      if (v.length < 8) return 'Mínimo de 8 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('Descrição (sua apresentação)'),
                  _construirCampoTexto(
                    dica: 'Ex: Especialista em elétrica residencial',
                    icone: Icons.description_outlined,
                    controller: _descricaoController,
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('Especialidade'),
                  _construirCampoTexto(
                    dica: 'Ex: ELETRICISTA, PINTORA, BABÁ...',
                    icone: Icons.work_outline,
                    controller: _especialidadeController,
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('CEP'),
                  _construirCampoTexto(
                    dica: 'Ex: 00000-000',
                    icone: Icons.home_outlined,
                    controller: _cepController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'CEP obrigatório';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _construirLabel('Logradouro'),
                  _construirCampoTexto(
                    dica: 'Ex: Rua dos engenhos',
                    icone: Icons.home_outlined,
                    controller: _logradouroController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _construirLabel('Número'),
                            _construirCampoTexto(
                              dica: 'Ex: 12',
                              icone: Icons.home_outlined,
                              controller: _numeroController,
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Número obrigatório' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _construirLabel('Complemento'),
                            _construirCampoTexto(
                              dica: 'Ex: CASA A',
                              icone: Icons.home_outlined,
                              controller: _complementoController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _cadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A3A70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.branco,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Criar perfil',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.branco,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPrestador(),
                        ),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.branco,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'Já tem conta?\n'),
                          TextSpan(
                            text: 'Faça Login aqui!',
                            style: TextStyle(
                              color: AppColors.destaque,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirLabel(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          texto,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.branco,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _construirCampoTexto({
    required String dica,
    required IconData icone,
    bool esSenha = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: esSenha ? _senhaOculta : false,
      style: const TextStyle(color: AppColors.principalEscura),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD2C3D9),
        hintText: dica,
        hintStyle:
            TextStyle(color: AppColors.principalEscura.withOpacity(0.5)),
        prefixIcon: Icon(icone, color: AppColors.principalEscura),
        suffixIcon: esSenha
            ? IconButton(
                icon: Icon(
                  _senhaOculta
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.principalEscura,
                ),
                onPressed: () {
                  setState(() {
                    _senhaOculta = !_senhaOculta;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
