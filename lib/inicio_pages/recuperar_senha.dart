import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../services/auth_service.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key});

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final _emailController = TextEditingController();
  final _codigoController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _codigoEnviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codigoController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _enviarCodigo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.solicitarRedefinicaoSenha(
        _emailController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de teste: 123456'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      setState(() => _codigoEnviado = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _codigoEnviado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de teste: 123456'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _redefinir() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.redefinirSenha(
        email: _emailController.text.trim(),
        codigo: _codigoController.text.trim(),
        novaSenha: _novaSenhaController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha redefinida com sucesso!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código inválido. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.branco,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  _codigoEnviado ? 'Redefinir senha' : 'Recuperar senha',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.destaque,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _codigoEnviado
                      ? 'Digite o código recebido e sua nova senha.'
                      : 'Digite seu e-mail cadastrado para receber um código de verificação.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.branco.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                _construirLabel('E-mail'),
                const SizedBox(height: 8),
                _construirCampoEmail(),
                if (_codigoEnviado) ...[
                  const SizedBox(height: 24),
                  _construirLabel('Código de verificação'),
                  const SizedBox(height: 8),
                  _construirCampoCodigo(),
                  const SizedBox(height: 24),
                  _construirLabel('Nova senha'),
                  const SizedBox(height: 8),
                  _construirCampoSenha(
                    controller: _novaSenhaController,
                    dica: 'Mínimo 8 caracteres',
                  ),
                  const SizedBox(height: 24),
                  _construirLabel('Confirmar senha'),
                  const SizedBox(height: 8),
                  _construirCampoSenha(
                    controller: _confirmarSenhaController,
                    dica: 'Repita a nova senha',
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _codigoEnviado ? _redefinir : _enviarCodigo,
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
                            _codigoEnviado
                                ? 'Redefinir senha'
                                : 'Enviar código',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.branco,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
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
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.branco.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _construirCampoEmail() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      enabled: !_codigoEnviado,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'E-mail obrigatório';
        if (!v.contains('@')) return 'E-mail inválido';
        return null;
      },
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.branco,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'seu@email.com',
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.branco.withOpacity(0.3),
        ),
        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.destaque, size: 20),
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

  Widget _construirCampoCodigo() {
    return TextFormField(
      controller: _codigoController,
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Código obrigatório';
        if (v.trim().length < 4) return 'Código inválido';
        return null;
      },
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.branco,
        fontSize: 14,
        letterSpacing: 4,
      ),
      decoration: InputDecoration(
        hintText: '123456',
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.branco.withOpacity(0.3),
          letterSpacing: 4,
        ),
        prefixIcon: const Icon(Icons.pin_outlined, color: AppColors.destaque, size: 20),
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

  Widget _construirCampoSenha({
    required TextEditingController controller,
    required String dica,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Senha obrigatória';
        if (v.length < 8) return 'Mínimo 8 caracteres';
        if (controller == _confirmarSenhaController &&
            v != _novaSenhaController.text) return 'Senhas não conferem';
        return null;
      },
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.branco,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: dica,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.branco.withOpacity(0.3),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.destaque, size: 20),
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
