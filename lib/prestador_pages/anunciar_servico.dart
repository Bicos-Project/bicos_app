import 'package:bicos_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bicos_app/prestador_pages/main_navigation_prestador.dart';

class AnunciarServicoPage extends StatefulWidget {
  const AnunciarServicoPage({super.key});

  @override
  State<AnunciarServicoPage> createState() => _AnunciarServicoPageState();
}

class _AnunciarServicoPageState extends State<AnunciarServicoPage> {
  double _raioAtendimento = 15.0;

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight(600),
        ),
        textAlign: TextAlign.center,
      ),
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
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 80),
          child: _construirHeader(),
        ),
        backgroundColor: AppColors.principal,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'NOVO ANÚNCIO',
                  style: TextStyle(
                    color: AppColors.branco,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Destaque seu talento\npara a comunidade.',
                  style: TextStyle(
                    color: AppColors.branco,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),

                // Container de Upload
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.branco,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage('assets/image_icon.png'),
                        height: 60,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Adicionar fotos do serviço',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Mostre o seu melhor trabalho (Até 5 fotos)',
                        style: TextStyle(fontSize: 13, color: AppColors.cinza),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'NOME DO ANÚNCIO',
                  style: TextStyle(color: AppColors.branco, fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: _inputStyle('Ex: Eletricista Residencial 24h'),
                ),

                const SizedBox(height: 20),
                const Text(
                  'CATEGORIA DO SERVIÇO',
                  style: TextStyle(color: AppColors.branco, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildChip('Beleza\ne Estética'),
                    _buildChip('Serviços\nDomésticos'),
                    _buildChip('Reparos\nRápidos'),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  'DESCRIÇÃO E EXPERIÊNCIA',
                  style: TextStyle(color: AppColors.branco, fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: _inputStyle(
                    'Conte um pouco sobre sua trajetória...',
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'VALOR BASE (R\$)',
                  style: TextStyle(color: AppColors.branco, fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: _inputStyle('R\$ 0,00'),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RAIO DE ATENDIMENTO',
                      style: TextStyle(color: AppColors.branco, fontSize: 11),
                    ),
                    Text(
                      '${_raioAtendimento.toInt()} km',
                      style: const TextStyle(
                        color: AppColors.destaque,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.branco,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      activeTrackColor: const Color(0xFFDFF481),
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFFDFF481),
                      overlayColor: Colors.black.withOpacity(0.05),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10.0,
                      ),
                    ),
                    child: Slider(
                      value: _raioAtendimento,
                      min: 0,
                      max: 50,
                      onChanged: (value) =>
                          setState(() => _raioAtendimento = value),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MainNavigationPrestador(), // Volta para a navegação principal do prestador
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDFF481),
                      foregroundColor: const Color(0xFF425F23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Publicar Anúncio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Ao publicar, você concorda com os nossos Termos de Uso.',
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
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
}
