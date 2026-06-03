import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prestador_model.dart';

class FavoritosService {
  static const _key = 'favoritos';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  static Future<List<Prestador>> listar() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Prestador.fromJson(e)).toList();
  }

  static Future<void> toggle(Prestador prestador) async {
    final lista = await listar();
    final idx = lista.indexWhere((p) => p.nome == prestador.nome);
    if (idx >= 0) {
      lista.removeAt(idx);
    } else {
      lista.add(prestador);
    }
    await _salvar(lista);
  }

  static Future<bool> isFavorito(String nome) async {
    final lista = await listar();
    return lista.any((p) => p.nome == nome);
  }

  static Future<void> remover(String nome) async {
    final lista = await listar();
    lista.removeWhere((p) => p.nome == nome);
    await _salvar(lista);
  }

  static Future<void> _salvar(List<Prestador> lista) async {
    final prefs = await _prefs;
    final raw = jsonEncode(lista.map((p) => p.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
