import 'package:bicos_app/core/app_colors.dart';
import 'package:bicos_app/prestador_pages/chat_prestador.dart';
import 'package:flutter/material.dart';

class VisualizacaoPropostaPage extends StatelessWidget {
  const VisualizacaoPropostaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.principal,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _construirHeader(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Card Principal Branco
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.branco,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ajuste de chuveiro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'DESCRIÇÃO',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cinza,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cinza.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'O meu chuveiro está com um vazamento muito forte.',
                        style: TextStyle(color: AppColors.cinza),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'IMAGENS',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cinza,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/chuveiro.png', // Substitua pelo seu asset
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card Agendamento (Roxo Translúcido)
              _buildInfoCard(
                title: 'AGENDAMENTO',
                content: '07/04/2026, 16:00',
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 12),

              // Card Localização (Roxo Translúcido)
              _buildInfoCard(
                title: 'LOCALIZAÇÃO',
                content: 'Endereço ou Bairro',
                subContent: 'PRIVACIDADE GARANTIDA',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 32),

              // Botão de Ação Verde
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatVendedor(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.destaque,
                    foregroundColor: const Color(0xFF425F23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fazer orçamento',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirHeader() {
    return Stack(
      children: [
        Image.asset('assets/header.png', fit: BoxFit.fill),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/bicos_logo2.png', height: 32),
                Container(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: Image.asset('assets/perfil.png', fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    String? subContent,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.branco.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.branco, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subContent != null)
                Text(
                  subContent,
                  style: const TextStyle(color: AppColors.branco, fontSize: 10),
                ),
            ],
          ),
          Icon(icon, color: AppColors.destaque, size: 24),
        ],
      ),
    );
  }
}
