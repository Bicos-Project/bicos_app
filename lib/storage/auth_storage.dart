import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';
  static const _userNomeKey = 'user_nome';
  static const _userEmailKey = 'user_email';
  static const _userPerfilKey = 'user_perfil';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  static Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUserData({
    required int id,
    required String nome,
    required String email,
    required String perfil,
  }) async {
    final prefs = await _prefs;
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userNomeKey, nome);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userPerfilKey, perfil);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await _prefs;
    return {
      'id': prefs.getInt(_userIdKey),
      'nome': prefs.getString(_userNomeKey),
      'email': prefs.getString(_userEmailKey),
      'perfil': prefs.getString(_userPerfilKey),
    };
  }

  static Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNomeKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPerfilKey);
  }
}
