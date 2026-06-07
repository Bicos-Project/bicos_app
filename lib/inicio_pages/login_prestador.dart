import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import 'cadastro_prestador.dart';
import '../components/main_navigation_prestador.dart';
import '../providers/auth_provider.dart';

class LoginPrestador extends StatefulWidget {
  const LoginPrestador({super.key});

  @override
  State<LoginPrestador> createState() => _LoginPrestadorState();
}

class _LoginPrestadorState extends State<LoginPrestador> {
  bool _senhaOculta = true;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthProvider>().clearError();
    context
        .read<AuthProvider>()
        .loginPrestador(_emailController.text.trim(), _senhaController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/bicos_logo1.png', height: 80),
                  const SizedBox(height: 24),
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
                        const TextSpan(text: 'Bem vindo de volta\nao '),
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
                  const SizedBox(height: 48),
                  _construirLabel('E-mail'),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 24),
                  _construirLabel('Senha'),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    dica: '••••••••••••',
                    icone: Icons.lock_outline,
                    esSenha: true,
                    controller: _senhaController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Senha obrigatória';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      if (auth.isAuthenticated) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationPrestador(),
                            ),
                          );
                        });
                      }
                      if (auth.error != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.error!),
                              backgroundColor: Colors.red.shade700,
                            ),
                          );
                          auth.clearError();
                        });
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : _entrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A3A70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.branco,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Entrar',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.branco,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CadastroPrestadorPage(),
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
                          const TextSpan(text: 'Não possui conta?\n'),
                          TextSpan(
                            text: 'Cadastre-se aqui!',
                            style: TextStyle(
                              color: AppColors.destaque,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.destaque,
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
      child: Text(
        texto,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.branco,
          fontSize: 14,
          fontWeight: FontWeight.w700,
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
