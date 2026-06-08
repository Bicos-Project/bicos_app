import 'package:bicos_app/models/mensagem_response.dart';
import 'package:bicos_app/models/solicitacao_response.dart';
import 'package:bicos_app/services/mensagem_service.dart';
import 'package:bicos_app/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class ChatClientePage extends StatefulWidget {
  final SolicitacaoResponse solicitacao;

  const ChatClientePage({super.key, required this.solicitacao});

  @override
  State<ChatClientePage> createState() => _ChatClientePageState();
}

class _ChatClientePageState extends State<ChatClientePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MensagemResponse> _mensagens = [];
  bool _isLoading = true;
  int? _userId;
  String? _perfil;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final userData = await AuthStorage.getUserData();
    _userId = userData['id'] as int?;
    _perfil = userData['perfil'] as String?;
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
    if (texto.isEmpty || _userId == null) return;

    _controller.clear();
    try {
      await MensagemService.enviar(
        solicitacaoId: widget.solicitacao.id,
        remetenteId: _userId!,
        tipoRemetente: _perfil ?? 'CLIENTE',
        texto: texto,
      );
      await _carregarMensagens();
    } catch (_) {}
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
                Row(
                  children: [
                    Text(
                      widget.solicitacao.anuncioTitulo ?? 'Serviço',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.fundoPreto.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Solicitação #${widget.solicitacao.id}',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.fundoPreto.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const SizedBox(height: 4),
          Text(
            hora,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.branco.withOpacity(0.4),
              fontSize: 10,
            ),
          ),
        ],
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
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.attach_file,
              color: AppColors.principalEscura.withOpacity(0.9),
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.camera_alt_outlined,
              color: AppColors.principalEscura.withOpacity(0.75),
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
    );
  }
}
