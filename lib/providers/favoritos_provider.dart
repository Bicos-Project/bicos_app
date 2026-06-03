import 'package:flutter/foundation.dart';
import '../models/prestador_model.dart';
import '../services/favoritos_service.dart';

class FavoritosProvider extends ChangeNotifier {
  List<Prestador> _favoritos = [];

  List<Prestador> get favoritos => _favoritos;

  Future<void> carregar() async {
    _favoritos = await FavoritosService.listar();
    notifyListeners();
  }

  bool isFavorito(String nome) {
    return _favoritos.any((f) => f.nome == nome);
  }

  Future<void> toggle(Prestador p) async {
    await FavoritosService.toggle(p);
    _favoritos = await FavoritosService.listar();
    notifyListeners();
  }

  Future<void> remover(String nome) async {
    await FavoritosService.remover(nome);
    _favoritos = await FavoritosService.listar();
    notifyListeners();
  }
}
