import 'dart:io';
import 'package:bicos_app/models/mensagem_response.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/services/mensagem_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';

class ChatClientePage extends StatefulWidget {
  final SolicitacaoResponse solicitacao;

  const ChatClientePage({super.key, required this.solicitacao});

  @override
  State<ChatClientePage> createState() => _ChatClientePageState();
}

class _ChatClientePageState extends State<ChatClientePage> {
  String _fullUrl(String relative) => 'http://localhost:8080$relative';

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  List<MensagemResponse> _mensagens = [];
  bool _isLoading = true;
  int? _userId;
  String? _perfil;
  String? _nome;
  File? _pendingImage;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final userData = await AuthStorage.getUserData();
    _userId = userData['id'] as int?;
    _perfil = userData['perfil'] as String?;
    _nome = userData['nome'] as String?;

    await _carregarMensagens();
  }

  Future<void> _carregarMensagens() async {
    try {
      final list = await MensagemService.listar(widget.solicitacao.id);
      if (mounted) setState(() => _mensagens = list);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    _rolarParaFinal();
  }

  void _rolarParaFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _enviarMensagem() async {
    final texto = _controller.text.trim();
    if ((texto.isEmpty && _pendingImage == null) || _userId == null) return;

    final image = _pendingImage;
    _pendingImage = null;
    _controller.clear();
    if (mounted) setState(() {});
    try {
      await MensagemService.enviar(
        solicitacaoId: widget.solicitacao.id,
        remetenteId: _userId!,
        tipoRemetente: _perfil ?? 'CLIENTE',
        texto: texto,
        imagem: image,
      );
      await _carregarMensagens();
    } catch (_) {}
  }

  Future<void> _selecionarImagem() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() => _pendingImage = File(file.path));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              const Color.fromARGB(255, 64, 18, 75),
              AppColors.principal,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _construirHeader(context),
              _isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.destaque),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _mensagens.length,
                        itemBuilder: (context, index) {
                          final msg = _mensagens[index];
                          return _construirBolhaMensagem(msg);
                        },
                      ),
                    ),
              _construirCampoMensagem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: AppColors.branco,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.principal,
              size: 20,
            ),
          ),
          CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.principalEscura.withOpacity(0.1),
            child: Text(
              widget.solicitacao.prestadorNome.isNotEmpty
                  ? widget.solicitacao.prestadorNome[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppColors.principalEscura,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.solicitacao.prestadorNome,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.principalEscura,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.solicitacao.categoriaNome ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.fundoPreto.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.principal,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBolhaMensagem(MensagemResponse msg) {
    final isMinha = msg.remetenteId == _userId && msg.tipoRemetente == _perfil;
    final hora = msg.dataHora != null
        ? msg.dataHora!.substring(11, 16)
        : '';

    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMinha ? 60 : 0,
        right: isMinha ? 0 : 60,
      ),
      child: Column(
        crossAxisAlignment: isMinha
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMinha) ...[
                _construirAvatarMensagem(
                    widget.solicitacao.prestadorNome),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: msg.imagemUrl != null
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMinha ? const Color(0xFF5A3A70) : AppColors.branco,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMinha ? 18 : 4),
                      bottomRight: Radius.circular(isMinha ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (msg.imagemUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                          child: Image.network(
                            _fullUrl(msg.imagemUrl!),
                            width: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                      if (msg.texto.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            msg.texto,
                            style: GoogleFonts.plusJakartaSans(
                              color: isMinha ? AppColors.branco : AppColors.principalEscura,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isMinha) ...[
                const SizedBox(width: 8),
                _construirAvatarMensagem(_nome),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isMinha ? 0 : 32),
            child: Text(
              hora,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.branco.withOpacity(0.4),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirAvatarMensagem(String? nome) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.principalEscura.withOpacity(0.15),
      child: Text(
        nome != null && nome.isNotEmpty ? nome[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppColors.principalEscura,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _construirCampoMensagem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.branco,
        border: Border(
          top: BorderSide(
            color: AppColors.principal.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_pendingImage != null)
            Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(_pendingImage!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => setState(() => _pendingImage = null),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18, color: AppColors.branco),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              IconButton(
                onPressed: _selecionarImagem,
                icon: Icon(
                  Icons.image_outlined,
                  color: AppColors.principalEscura.withOpacity(0.9),
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2C3D9).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.principalEscura.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.principalEscura,
                      fontSize: 14,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _enviarMensagem(),
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: AppColors.principalEscura.withOpacity(0.4),
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _enviarMensagem,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.principalEscura,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: AppColors.branco,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
