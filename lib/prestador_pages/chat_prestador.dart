import 'package:bicos_app/cliente_pages/avaliacao.dart';
import 'package:bicos_app/prestador_pages/andamento_servico.dart';
import 'package:bicos_app/prestador_pages/home_page_prestador.dart';
import 'package:bicos_app/prestador_pages/visualizacao_chats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

// Modelo de mensagem
class Mensagem {
  final String texto;
  final bool isMinha;
  final String horario;

  const Mensagem({
    required this.texto,
    required this.isMinha,
    required this.horario,
  });
}

class ChatVendedor extends StatefulWidget {
  const ChatVendedor({super.key});

  @override
  State<ChatVendedor> createState() => _ChatVendedorState();
}

class _ChatVendedorState extends State<ChatVendedor> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mensagens de exemplo baseadas no protótipo
  final List<Mensagem> _mensagens = [
    const Mensagem(
      texto:
          'Oi Josefino! Tudo bem? Me chamo Carlos e teria interesse em consertar meu encanamento.',
      isMinha: true,
      horario: '14:25',
    ),
    const Mensagem(
      texto: 'Teria disponibilidade? 😊',
      isMinha: true,
      horario: '14:26',
    ),
    const Mensagem(
      texto:
          'Olá Carlos! Teria sim, poderia me informar o estado atual do encanamento? O valor é fixo de R\$ 100 reais.',
      isMinha: false,
      horario: '14:26',
    ),
    const Mensagem(
      texto: 'Está ocorrendo grande vazamento no quarto. Encanamento antigo.',
      isMinha: true,
      horario: '14:28',
    ),
    const Mensagem(
      texto: 'Certo! Vamos agendar uma visita!',
      isMinha: false,
      horario: '14:28',
    ),
  ];

  bool _outroEstaDigitando =
      true; // Para exibir o indicador "Carlos está digitando"

  void _enviarMensagem() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensagens.add(
        Mensagem(texto: texto, isMinha: true, horario: _horaAtual()),
      );
      _controller.clear();
    });

    // Rola para o final após enviar
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

  String _horaAtual() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
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
      // 1. Remova a cor sólida do Scaffold
      body: Container(
        // 2. Aplica o gradiente radial em toda a tela
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center, // Começa exatamente no meio
            radius:
                1.0, // Define o quão longe o gradiente se espalha (1.0 = preenche o container)
            colors: [
              // A ordem aqui define o "do meio para fora"
              const Color.fromARGB(255, 64, 18, 75),
              AppColors.principal, // COR 2: Sua cor principal (meio termo)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── HEADER ──
              _construirHeader(context),

              // ── BOTÃO "VISUALIZAR SOLICITAÇÃO" ──
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _construirBotaoRecusarProposta(),
                    _construirBotaoAceitarProposta(),
                  ],
                ),
              ),

              // ── SEPARADOR COM DATA ──
              _construirSeparadorData('PROPOSTA ENVIADA · HOJE ÀS 14:23'),

              const SizedBox(height: 8),

              // ── LISTA DE MENSAGENS ──
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _mensagens.length + (_outroEstaDigitando ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_outroEstaDigitando && index == _mensagens.length) {
                      return _construirIndicadorDigitando();
                    }
                    final msg = _mensagens[index];
                    return _construirBolhaMensagem(msg);
                  },
                ),
              ),

              // ── CAMPO DE TEXTO ──
              _construirCampoMensagem(),
            ],
          ),
        ),
      ),
    );
  }
  // ── WIDGETS AUXILIARES ──────────────────────────────────────────────

  Widget _construirHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: AppColors.branco,
      child: Row(
        children: [
          // Botão voltar
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VisualizacaoChats()),
            ),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.principal,
              size: 20,
            ),
          ),

          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.destaque, width: 2),
              color: const Color(0xFFD2C3D9),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/eletricista.png',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nome e status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Josefino Barros',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.principalEscura,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Eletricista · ',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.fundoPreto.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                      'Online agora',
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

          // Menu de opções
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

  Widget _construirBotaoRecusarProposta() {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePagePrestador(title: 'title'),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Color.fromARGB(255, 255, 0, 0),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      child: Text(
        'Recusar',
        style: GoogleFonts.plusJakartaSans(
          color: const Color.fromARGB(255, 255, 0, 0),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _construirBotaoAceitarProposta() {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AndamentoServicoPage()),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.destaque, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      child: Text(
        'Aceitar',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.destaque,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _construirSeparadorData(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.branco.withOpacity(0.2),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              texto,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.branco.withOpacity(0.5),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.branco.withOpacity(0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBolhaMensagem(Mensagem msg) {
    final isMinha = msg.isMinha;

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
            msg.horario,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.branco.withOpacity(0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirIndicadorDigitando() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.branco.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _construirPonto(delay: 0),
                const SizedBox(width: 4),
                _construirPonto(delay: 150),
                const SizedBox(width: 4),
                _construirPonto(delay: 300),
                const SizedBox(width: 10),
                Text(
                  'Carlos está digitando',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.branco.withOpacity(0.7),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPonto({required int delay}) {
    // Ponto animado simples usando TweenAnimationBuilder
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.branco.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
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
          // Botão anexo
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

          // Botão câmera
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AvaliacaoServico(nomePrestador: 'Mariana'),
                ),
              );
            },
            icon: Icon(
              Icons.camera_alt_outlined,
              color: AppColors.principalEscura.withOpacity(0.75),
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          const SizedBox(width: 4),

          // Campo de texto
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

          // Botão enviar
          MouseRegion(
            cursor:
                SystemMouseCursors.click, // Aqui acontece a mágica do 'pointer'
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
