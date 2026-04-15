import 'package:bicos_app/cliente_pages/avaliacao.dart';
import 'package:bicos_app/cliente_pages/chat_cliente.dart';
import 'package:bicos_app/prestador_pages/avaliacao_prestador.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AndamentoServicoClientePage extends StatelessWidget {
  const AndamentoServicoClientePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principal,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: _buildHeader(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClienteCard(),
            const SizedBox(height: 16),
            _buildTotalCard(),
            const SizedBox(height: 16),
            _buildProgressoServico(),
            const SizedBox(height: 16),
            _buildChatCliente(context),
            const SizedBox(height: 16),
            _buildResumoFinanceiro(),
            const SizedBox(height: 20),
            _buildBotaoPagamento(context),
            const SizedBox(height: 12),
            _buildLinkSuporte(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: AppBar(
        automaticallyImplyLeading:
            false, // Remove o botão voltar padrão se necessário
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Stack(
          children: [
            Image.asset(
              "assets/header.png",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/bicos_logo2.png", height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/perfil.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCliente(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatClientePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: Image.asset('assets/chat_cliente.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildClienteCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/perfil.png'),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prestador de serviço',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.preto,
                  ),
                ),
                const Text(
                  'Ajuste de chuveiro • 4h • Amanhã às 09:00',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const Text(
            'Há 5 min',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.principal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
            child: const Text(
              'Visualizar',
              style: TextStyle(color: AppColors.principal, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.principalEscura,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'R\$ 100,00',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.branco,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressoServico() {
    // Etapas: Orçamento, Em andamento, Esperando pagamento, Finalizado
    const etapas = [
      'Orçamento',
      'Em andamento',
      'Esperando\npagamento',
      'Finalizado',
    ];
    const labels = ['', 'Em andamento', '', 'Finalizado'];
    const etapaAtual = 1; // 0-based, "Em andamento"

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Labels de cima (Em andamento / Finalizado)
          Row(
            children: List.generate(etapas.length, (i) {
              if (labels[i].isEmpty) return const Expanded(child: SizedBox());
              return Expanded(
                child: Text(
                  labels[i],
                  textAlign: i == 1 ? TextAlign.center : TextAlign.right,
                  style: TextStyle(
                    fontSize: 10,
                    color: i <= etapaAtual ? AppColors.principal : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),

          // Linha de progresso com círculos
          Row(
            children: List.generate(etapas.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Linha entre os círculos
                final segmentoAtivo = (i ~/ 2) < etapaAtual;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: segmentoAtivo
                        ? AppColors.principal
                        : Colors.grey.shade300,
                  ),
                );
              } else {
                final etapaIndex = i ~/ 2;
                final ativo = etapaIndex <= etapaAtual;
                return Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ativo ? AppColors.principal : Colors.grey.shade300,
                    border: Border.all(
                      color: ativo ? AppColors.principal : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 6),

          // Labels de baixo (Orçamento / Esperando pagamento)
          Row(
            children: List.generate(etapas.length, (i) {
              if (i == 1 || i == 3) return const Expanded(child: SizedBox());
              return Expanded(
                child: Text(
                  etapas[i],
                  textAlign: i == 0 ? TextAlign.left : TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoFinanceiro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _buildLinhaFinanceira('Total', 'R\$ 100,00', destaque: false),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _buildLinhaFinanceira('Taxa Bicos', 'R\$ 15,00', destaque: false),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _buildLinhaFinanceira('Subtotal', 'R\$ 115,00', destaque: false),
          const SizedBox(height: 12),
          _buildLinhaFinanceira('Total à pagar', 'R\$ 115,00', destaque: true),
        ],
      ),
    );
  }

  Widget _buildLinhaFinanceira(
    String label,
    String valor, {
    required bool destaque,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: destaque ? 15 : 13,
            fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
            color: destaque ? AppColors.preto : Colors.grey.shade700,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: destaque ? 16 : 13,
            fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
            color: destaque ? AppColors.principal : AppColors.preto,
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoPagamento(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pagamento realizado com sucesso!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AvaliacaoServico()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.destaque,
          foregroundColor: AppColors.principalEscura,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: const Text(
          'Confirmar Pagamento',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLinkSuporte() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.white60, size: 14),
        const SizedBox(width: 6),
        const Text(
          'ALGO DE ERRADO? ',
          style: TextStyle(color: Colors.white60, fontSize: 11),
        ),
        GestureDetector(
          onTap: () {
          },
          child: const Text(
            'FALE CONOSCO',
            style: TextStyle(
              color: AppColors.destaque,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.destaque,
            ),
          ),
        ),
      ],
    );
  }
}
