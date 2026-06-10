import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './inicio_pages/tela_inicial.dart';
import 'core/app_colors.dart';
import 'providers/auth_provider.dart';
import 'providers/favoritos_provider.dart';
import 'services/api_client.dart';

void main() {
  ApiClient.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<FavoritosProvider>(
          create: (_) => FavoritosProvider()..carregar(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.principal,
        ),
        home: const TelaInicialPage(),
      ),
    );
  }
}
