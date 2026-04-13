import 'package:flutter/material.dart';

class AnunciarServicoPage extends StatefulWidget {
  const AnunciarServicoPage({super.key});

  @override
  State<AnunciarServicoPage> createState() => _AnunciarServicoPageState();
}

class _AnunciarServicoPageState extends State<AnunciarServicoPage> {
  double _raioAtendimento = 15.0;

  Widget _buildChip(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color:  Colors.white.withOpacity(0.2), // Usando o roxo de superfície
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'), fit: BoxFit.fill
          )
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Deixa o gradiente aparecer
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/header.png'),
                fit: BoxFit.fill,
                ),
              ),
            ),
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Ou apenas Icons.arrow_back
              color: Color.fromRGBO(223, 244, 129, 1),      // A cor desejada
              onPressed: () => Navigator.pop(context),
            ),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image(image: AssetImage('assets/bicos_logo2.png'), height: 30,)
                ],
              ),
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
            ],
          ),
        ),
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
                    color: colorScheme.onPrimary.withOpacity(0.7),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Destaque seu talento\npara a comunidade.',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/image_icon.png'), height: 60,),
                      const SizedBox(height: 12),
                      const Text(
                        'Adicionar fotos do serviço',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
                      ),
                      const Text(
                        'Mostre o seu melhor trabalho (Até 5 fotos)',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text('NOME DO ANÚNCIO', style: TextStyle(color: Colors.white, fontSize: 11)),
                const SizedBox(height: 8),
                TextField(decoration: _inputStyle('Ex: Eletricista Residencial 24h')),

                const SizedBox(height: 20),
                const Text('CATEGORIA DO SERVIÇO', style: TextStyle(color: Colors.white, fontSize: 11)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 25,
                  runSpacing: 20,
                  children: [
                    _buildChip('Beleza\ne Estética', colorScheme),
                    _buildChip('Serviços\nDomésticos', colorScheme),
                    _buildChip('Reparos\nRápidos', colorScheme),
                  ],
                ),

                const SizedBox(height: 20),
                const Text('DESCRIÇÃO E EXPERIÊNCIA', style: TextStyle(color: Colors.white, fontSize: 11)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: _inputStyle('Conte um pouco sobre sua trajetória., \nferramentas que utiliza e difirenciais...'),
                ),

                const SizedBox(height: 20),
                const Text('VALOR BASE (R\$)', style: TextStyle(color: Colors.white, fontSize: 11)),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: _inputStyle('R\$ 0,00'),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('RAIO DE ATENDIMENTO', style: TextStyle(color: Colors.white, fontSize: 11)),
                    Text(
                      '${_raioAtendimento.toInt()} km', 
                      style: TextStyle(color: Color.fromRGBO(223, 244, 129, 1), fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                Container(
                  height: 50, // Altura da barra branca
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // O fundo branco que você pediu
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      // Altura da linha do slider
                      trackHeight: 2, 
                      // Cor da parte já "percorrida" (Verde limão do seu ColorScheme)
                      activeTrackColor: Color.fromRGBO(223, 244, 129, 1), 
                      // Cor da parte que falta percorrer (Cinza claro para contrastar com o branco)
                      inactiveTrackColor: Colors.grey.shade300, 
                      // Cor da bolinha
                      thumbColor: const Color.fromRGBO(223, 244, 129, 1),
                      overlayColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                      // Remove as margens internas padrão do Slider para encostar nas bordas se necessário
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                    ),
                    child: Slider(
                      value: _raioAtendimento,
                      min: 0,
                      max: 50,
                      onChanged: (value) => setState(() => _raioAtendimento = value),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(223, 244, 129, 1),
                      foregroundColor: Color.fromARGB(255, 66, 95, 35),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Publicar Anúncio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
}