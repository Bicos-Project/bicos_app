import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/prestador_foto_model.dart';
import '../services/auth_service.dart';
import '../services/avatar_service.dart';
import '../storage/auth_storage.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  int? _userId;
  String? _nome;
  String? _email;
  String? _perfil;
  String? _avatarPath;
  String? _avatarUrl;
  List<PrestadorFoto> _fotos = [];
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  int? get userId => _userId;
  String? get nome => _nome;
  String? get email => _email;
  String? get perfil => _perfil;
  String? get avatarPath => _avatarPath;
  String? get avatarUrl => _avatarUrl;
  List<PrestadorFoto> get fotos => _fotos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  Future<bool> init() async {
    final token = await AuthStorage.getToken();
    if (token == null) return false;

    final userData = await AuthStorage.getUserData();
    if (userData['id'] == null) return false;

    _token = token;
    _userId = userData['id'] as int?;
    _nome = userData['nome'] as String?;
    _email = userData['email'] as String?;
    _perfil = userData['perfil'] as String?;
    _avatarPath = await AvatarService.getSavedPath();
    notifyListeners();
    return true;
  }

  Future<void> loginCliente(String email, String senha) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.loginCliente(email, senha);
      _token = response.token;
      _userId = response.id;
      _nome = response.nome;
      _email = response.email;
      _perfil = response.perfil;
      _avatarUrl = response.fotoUrl;
      _avatarPath = await AvatarService.getSavedPath();
      await AuthStorage.saveToken(response.token);
      await AuthStorage.saveUserData(
        id: response.id,
        nome: response.nome,
        email: response.email,
        perfil: response.perfil,
      );
    } on DioException catch (e) {
      _error = AuthService.extrairErro(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginPrestador(String email, String senha) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.loginPrestador(email, senha);
      _token = response.token;
      _userId = response.id;
      _nome = response.nome;
      _email = response.email;
      _perfil = response.perfil;
      _avatarUrl = response.fotoUrl;
      _avatarPath = await AvatarService.getSavedPath();
      await AuthStorage.saveToken(response.token);
      await AuthStorage.saveUserData(
        id: response.id,
        nome: response.nome,
        email: response.email,
        perfil: response.perfil,
      );
    } on DioException catch (e) {
      _error = AuthService.extrairErro(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setAvatarPath(String path) async {
    _avatarPath = path;
    notifyListeners();
  }

  void setFotos(List<PrestadorFoto> fotos) {
    _fotos = fotos;
    if (fotos.isNotEmpty) {
      _avatarUrl = fotos.first.url;
    }
    notifyListeners();
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _nome = null;
    _email = null;
    _perfil = null;
    _avatarPath = null;
    _avatarUrl = null;
    _fotos = [];
    _error = null;
    await AuthStorage.clear();
    await AvatarService.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
